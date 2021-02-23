function __set_gitroot --on-event fish_prompt
    if type -q git && git rev-parse --is-inside-work-tree &> /dev/null
        set -gx GR (git rev-parse --show-toplevel)
    else
        set -e GR
    end
end

