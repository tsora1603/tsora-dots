if status is-interactive
    set fish_greeting ""
    fastfetch

    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

    if not test -S $SSH_AUTH_SOCK
        ssh-agent -a $SSH_AUTH_SOCK > /dev/null
        ssh-add ~/.ssh/github ~/.ssh/aur
    end
end



# Created by `pipx` on 2026-04-03 23:18:10
set PATH $PATH /home/tsora/Development/tsora-dots/dots/.local/bin
