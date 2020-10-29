# Defined in - @ line 1
function cat --description 'alias cat=bat' --wraps bat
    if type -q bat
        bat $argv;
    else
        command cat $argv;
    end
end
