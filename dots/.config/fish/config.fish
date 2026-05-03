set -g fish_prompt_pwd_dir_length 0
set -g fish_transient_prompt 1
set -g __fish_git_prompt_show_informative_status true


# eza config
alias ls "eza --icons"
alias ll "eza --icons -l --git --group-directories-first --time-style long-iso"
alias la "eza --icons -la"
alias lt "eza --icons --tree"  # tree view

if status is-interactive
    set fish_greeting ""
    fastfetch
end


# Created by `pipx` on 2026-04-03 23:18:10
set PATH $PATH /home/tsora/Development/tsora-dots/dots/.local/bin
