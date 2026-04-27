function fish_prompt
    set -l last_status $status

    set -l dir_bg green
    set -l git_bg cyan
    set -l arrow \uE0B0

    # Transient — minimal redraw for old prompts
    if contains -- --final-rendering $argv
        if test $last_status -ne 0
            echo -n (set_color red)"❱ "(set_color normal)
        else
            echo -n (set_color green)"❱ "(set_color normal)
        end
        return
    end

    # Directory segment
    echo ""
    echo -n "┌"
    set_color --background $dir_bg black
    echo -n "  "(prompt_pwd)" "
    set_color $dir_bg --background $git_bg
    echo -n $arrow

    # Git segment
    set -l __fish_git_prompt_show_informative_status true
    set -l __fish_git_prompt_showuntrackedfiles true
    set_color black --background $git_bg
    echo -n " 󰊤 "(fish_git_prompt "%s")" "
    set_color $git_bg normal
    echo -n $arrow

    # Prompt character
    set_color normal
    echo ""
    echo -n "└❱❰▸°❱ "
end
