function fish_right_prompt
    set -l duration $CMD_DURATION  # milliseconds

    # Status indicator
    if test $last_status -ne 0
        echo -n (set_color red)"{✗} $last_status "(set_color normal)
    else
        echo -n (set_color green)"{✓}"(set_color normal)
    end

    # Duration — only show if command took more than 1 second
    if test $duration -ge 1000
        set -l secs (math --scale=1 $duration / 1000)
        set_color brgrey
        echo -n (set_color brgrey)"took {$secs}s "
    end

    if contains -- --final-rendering $argv
        return  # print nothing on the right for transient
    end

    echo -n (set_color $time_bg)"┘"
end