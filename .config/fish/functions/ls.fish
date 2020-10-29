# Defined in - @ line 1
function ls --description 'alias ls=exa' --wraps exa
    if type -q exa
        exa $argv;
    else
        command ls $argv;
    end
end
