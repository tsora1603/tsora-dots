function fish_right_prompt
    set -l last_status $status
    set -l duration $CMD_DURATION  # milliseconds

    # Status indicator
    if test $last_status -ne 0
        echo -n (set_color red)"✗ $last_status  "(set_color normal)
    else
        echo -n (set_color green)"✓  "(set_color normal)
    end

    # Duration — only show if command took more than 1 second
    if test $duration -ge 1000
        set -l secs (math --scale=1 $duration / 1000)
        echo -n (set_color yellow)"took {$secs}s  "(set_color normal)
    end

    # Time
    set -l _h (date "+%H"); set -l _t (date "+%I:%M"); echo -n (set_color brblack)"$_t "(if test $_h -lt 12; echo AM; else; echo PM; end)(set_color normal)
end
