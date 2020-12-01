if ! test -e ~/.cache/fish_setup
    set -Ua fish_user_paths ~/go/bin
    set -Ua fish_user_paths ~/.local/bin
    set -Ua fish_user_paths ~/.cargo/bin
    echo "To finish please run: "
    echo "curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher"
    echo "fisher update"
    touch ~/.cache/fish_setup
end
