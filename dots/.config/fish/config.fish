if status is-interactive
# Commands to run in interactive sessions can go here
end

set fish_greeting ""
fastfetch

set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

if not test -S $SSH_AUTH_SOCK
    ssh-agent -a $SSH_AUTH_SOCK > /dev/null
    ssh-add ~/.ssh/github ~/.ssh/aur
end
