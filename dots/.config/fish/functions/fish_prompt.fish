function fish_prompt
    set -g last_status $status

    set -l dir_bg brwhite
    set -l git_bg brblack
    set -g time_bg green
    set -l dur_bg cyan
    set -l arrow_right \uE0B0
    set -l arrow_left \uE0B2

    # build segment strings to measure their visible length
    set -l dir_text "  "(prompt_pwd)" "
    set -l git_text "  "(fish_git_prompt "%s")" "

    # visible lengths: arrows + segment text
    # left side: "┌" + arrow_left + dir_text + arrow_right (git entry arrow)
    set -l left_len (math (string length --visible $dir_text) + 17)
    # right side: arrow_right + git_text + arrow_right (closing)
    set -l right_len (math (string length --visible $git_text) + 1)

    set -l dots_len (math $COLUMNS - $left_len - $right_len)
    set -l dots (string repeat -n $dots_len ·)

    # transient prompts
    if contains -- --final-rendering $argv
        if test $last_status -ne 0
            echo -n (set_color red)"❱❰❱ "(set_color normal)
        else
            echo -n (set_color green)"❱❰❱ "(set_color normal)
        end
        return
    end

    # directory segment
    echo ""
    echo -n "┌"
    set_color $dir_bg
    echo -n $arrow_left
    set_color --background $dir_bg black
    echo -n $dir_text
    set_color $dir_bg --background normal
    echo -n $arrow_right

    # git segment
    set_color black --background $git_bg
    echo -n $arrow_right
    set_color black --background $git_bg
    echo -n $git_text
    set_color $git_bg normal
    echo -n $arrow_right

    # dots fill
    set_color brblack
    echo -n $dots

    # time
    set_color $time_bg --background normal
    echo -n $arrow_left
    set_color $time_bg --background $time_bg
    set -l _h (date "+%H"); set -l _t (date "+%I:%M"); echo -n (set_color black)" $_t "(if test $_h -lt 12; echo "AM "; else; echo "PM "; end)(set_color normal)
    set_color $time_bg --background normal
    echo -n $arrow_right
    echo -n "┐"

    # prompt character
    set_color normal
    echo ""
    echo -n "└❱❰▸°❱ "
end