if ! test -e ~/.cache/fish_setup
    curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher
    set -Ua fish_user_paths ~/go/bin
    set -Ua fish_user_paths ~/.local/bin
    set -Ua fish_user_paths ~/.cargo/bin
    touch ~/.cache/fish_setup
end
