#!/usr/bin/env python3
"""
niri-vertical-consume.py
━━━━━━━━━━━━━━━━━━━━━━━━
Watches the niri IPC event stream and automatically runs
consume-or-expel-window-left on every new window that opens on your
secondary vertical monitor.

SETUP
─────
1. Find your vertical monitor's connector name:
       niri msg outputs
   Look for the one with Transform "90" or "270" (or just pick the one
   you want by its connector name, e.g. "DP-2", "HDMI-A-1", etc.).

2. Set VERTICAL_OUTPUT below (or pass it as the first CLI argument):
       python3 niri-vertical-consume.py DP-2

3. Auto-start with niri by adding this to ~/.config/niri/config.kdl:
       spawn-at-startup "python3" "/path/to/niri-vertical-consume.py" "DP-2"

REQUIRES
────────
  • Python 3.7+  (stdlib only, no extra packages)
  • niri with IPC support (0.1.9+)
  • $NIRI_SOCKET set in the environment (niri sets this automatically)

HOW IT WORKS
────────────
  1. Connects to $NIRI_SOCKET and sends {"EventStream": null} to get a
     continuous stream of compositor events.  (niri docs recommend this
     approach over shelling out to `niri msg` for scripts.)
  2. Builds a workspace-id → output-name map from WorkspacesChanged events.
  3. On every WindowOpenedOrChanged event it checks whether the window's
     workspace lives on VERTICAL_OUTPUT and whether this is truly a *new*
     window (not just a title/focus update on an existing one).
  4. For new windows on the vertical monitor it opens a *second* socket
     connection and sends:
         {"Action": {"ConsumeOrExpelWindowLeft": {"id": <window_id>}}}
     Using the explicit window id keeps the action correct even when the
     newly opened window isn't focused yet.
"""

import json
import os
import socket
import sys
import time
from typing import Optional

# ── Configuration ────────────────────────────────────────────────────────────

# Override via CLI argument or change the default here.
DEFAULT_VERTICAL_OUTPUT = "DP-2"

# Seconds to wait before firing the action after a new window appears.
# A tiny delay lets niri finish placing the window before we reorganise it.
ACTION_DELAY = 0.05

# ── IPC helpers ──────────────────────────────────────────────────────────────

def get_socket_path() -> str:
    path = os.environ.get("NIRI_SOCKET")
    if not path:
        raise RuntimeError(
            "NIRI_SOCKET is not set. "
            "Make sure you are running inside a niri session."
        )
    return path


def open_socket(path: str) -> socket.socket:
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    return sock


def send_request(sock: socket.socket, request: dict) -> dict:
    """Send a single JSON request and read back the single-line JSON reply."""
    sock.sendall((json.dumps(request) + "\n").encode())
    buf = b""
    while b"\n" not in buf:
        chunk = sock.recv(4096)
        if not chunk:
            raise EOFError("Socket closed before reply received")
        buf += chunk
    line = buf.split(b"\n", 1)[0]
    return json.loads(line)


def fire_action(socket_path: str, action: dict) -> None:
    """Open a fresh socket, fire one action, close it."""
    try:
        sock = open_socket(socket_path)
        reply = send_request(sock, {"Action": action})
        sock.close()
        if isinstance(reply, dict) and "Err" in reply:
            print(f"[niri-vertical-consume] Action error: {reply['Err']}", file=sys.stderr)
    except Exception as exc:
        print(f"[niri-vertical-consume] Failed to fire action: {exc}", file=sys.stderr)


# ── Event stream reader ───────────────────────────────────────────────────────

def iter_events(sock: socket.socket):
    """
    Yield parsed JSON event dicts from the niri event stream.
    niri sends one JSON object per line.
    """
    buf = b""
    while True:
        chunk = sock.recv(4096)
        if not chunk:
            return
        buf += chunk
        while b"\n" in buf:
            line, buf = buf.split(b"\n", 1)
            line = line.strip()
            if line:
                yield json.loads(line)


# ── Main logic ────────────────────────────────────────────────────────────────

def main(vertical_output: str) -> None:
    socket_path = get_socket_path()

    print(f"[niri-vertical-consume] Watching output: {vertical_output!r}")
    print(f"[niri-vertical-consume] Socket: {socket_path}")

    # workspace_id → output name  (kept up to date from WorkspacesChanged events)
    workspace_output: dict[int, str] = {}

    # Window ids we have already seen (to distinguish new windows from updates)
    known_windows: set[int] = set()

    event_sock = open_socket(socket_path)

    # Request the event stream — after this niri streams events indefinitely.
    event_sock.sendall((json.dumps("EventStream") + "\n").encode())

    # The first reply is {"Ok": {"EventStream": null}} — consume it.
    buf = b""
    while b"\n" not in buf:
        chunk = event_sock.recv(4096)
        if not chunk:
            raise EOFError("Socket closed immediately after EventStream request")
        buf += chunk
    first_line, leftover = buf.split(b"\n", 1)
    first_reply = json.loads(first_line)
    if not (isinstance(first_reply, dict) and "Ok" in first_reply):
        raise RuntimeError(f"Unexpected EventStream reply: {first_reply}")

    # Prepend any leftover bytes so they're not lost
    # (we re-inject them into a fake "buffer" by re-attaching to the generator)
    def event_gen():
        # Yield any lines already buffered after the handshake
        nonlocal leftover
        while b"\n" in leftover:
            line, leftover = leftover.split(b"\n", 1)
            line = line.strip()
            if line:
                yield json.loads(line)
        # Then yield from the live socket
        yield from iter_events(event_sock)

    print("[niri-vertical-consume] Listening for window events…")

    for event in event_gen():
        # ── WorkspacesChanged: keep our workspace→output map fresh ──────────
        if "WorkspacesChanged" in event:
            workspace_output = {
                ws["id"]: ws.get("output") or ""
                for ws in event["WorkspacesChanged"]["workspaces"]
            }
            continue

        # ── WindowsChanged: full resync of known windows ─────────────────────
        if "WindowsChanged" in event:
            known_windows = {w["id"] for w in event["WindowsChanged"]["windows"]}
            continue

        # ── WindowOpenedOrChanged ─────────────────────────────────────────────
        if "WindowOpenedOrChanged" in event:
            win = event["WindowOpenedOrChanged"]["window"]
            win_id: int = win["id"]
            ws_id: Optional[int] = win.get("workspace_id")

            is_new = win_id not in known_windows
            known_windows.add(win_id)

            if not is_new:
                continue  # Just a title/focus update — skip.

            if ws_id is None:
                continue  # Floating / unassigned window — skip.

            output = workspace_output.get(ws_id, "")
            if output != vertical_output:
                continue  # Not on our vertical monitor — skip.

            app_id = win.get("app_id") or "(unknown)"
            title = win.get("title") or ""
            print(
                f"[niri-vertical-consume] New window on {vertical_output}: "
                f"id={win_id} app={app_id!r} title={title!r} → consuming"
            )

            if ACTION_DELAY > 0:
                time.sleep(ACTION_DELAY)

            fire_action(
                socket_path,
                {"ConsumeOrExpelWindowLeft": {"id": win_id}},
            )

        # ── WindowClosed: clean up known_windows ──────────────────────────────
        elif "WindowClosed" in event:
            known_windows.discard(event["WindowClosed"]["id"])


def reconnect_loop(vertical_output: str) -> None:
    """Restart on connection drop (e.g. niri config reload)."""
    while True:
        try:
            main(vertical_output)
        except (EOFError, ConnectionResetError, BrokenPipeError) as exc:
            print(
                f"[niri-vertical-consume] Connection lost ({exc}), reconnecting in 2 s…",
                file=sys.stderr,
            )
            time.sleep(2)
        except KeyboardInterrupt:
            print("\n[niri-vertical-consume] Stopped.")
            break
        except Exception as exc:
            print(
                f"[niri-vertical-consume] Unexpected error: {exc}",
                file=sys.stderr,
            )
            time.sleep(2)


if __name__ == "__main__":
    output_name = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_VERTICAL_OUTPUT
    reconnect_loop(output_name)