if status is-interactive
    set fish_greeting ""
    fastfetch

    # Add keys if not already loaded
    if not ssh-add -l &>/dev/null
        ssh-add ~/.ssh/github ~/.ssh/aur
    end
end

# Created by `pipx` on 2026-04-03 23:18:10
set PATH $PATH /home/tsora/Development/tsora-dots/dots/.local/bin
