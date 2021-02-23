#!/usr/bin/env bash

OS_RELEASE="/etc/os-release"
SUDO="/usr/bin/sudo"
GUI=false
HTTP_REPO="https://github.com/ainmosni/dotfiles.git"
SSH_REPO="git@github.com:ainmosni/dotfiles.git"
GIT_CMD="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"


export PATH="$PATH:$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin"

info() {
    echo -e "\e[32mI:\e[0m $@"
}

error() {
    echo -e "\e[31mE:\e[0m $@"
}

fatal() {
    echo -e "\e[91mF:\e[0m $@"
    exit 1
}

fatal_on_fail() {
    (($? != 0)) && fatal $@
}

print_usage() {
    echo "$0 - Sets up an Ubuntu/Arch machine according to ainmosni's spec"
    echo ""
    echo "usage: $0"
    echo "usage: $0 -g"
    echo ""
    echo "Options:"
    echo "  -g\t\tSet up GUI."
    echo "  -h\t\tThis help text."
    echo ""
    exit 1
}

detect_os()
{
    info "Detecting OS..."

    if [ -f "$OS_RELEASE" ]; then
        . $OS_RELEASE
    else
        fatal "Unknown OS, existing."
    fi

    info "Detected OS: $NAME"
}

cache_sudo_password() {
    if [ ! -x "$SUDO" ]; then
        fatal "sudo not found or not executable."
    fi
    info "Initialising sudo password"
    $SUDO /usr/bin/true
    fatal_on_fail "sudo failed"
}

install_dependencies()
{
    case $ID in
        "ubuntu")
            install_ubuntu_dependencies
            (($GUI == "true")) && install_ubuntu_gui_dependencies
            ;;
        "arch")
            install_arch_dependencies
            (($GUI == "true")) && install_arch_gui_dependencies
            ;;
        *)
            fatal "Unsupported OS: $NAME"
            ;;
    esac

    install_rust
    install_precommit
    install_rust_dependencies
}

install_rust()
{
    info "Installing rust via rustup."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

install_precommit()
{
    info "Installing pre-commit framework."
    curl https://pre-commit.com/install-local.py | python3 -
}

install_ubuntu_dependencies()
{
    info "Installing Ubuntu prerequisites."
    sudo apt update
    sudo apt install -y apt-transport-https gnupg2 curl

    info "Setting up third party repositories."
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -

    info "Installing Ubuntu dependencies."
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y \
        fish \
        fzf \
        git \
        golang-go \
        httpie \
        jq \
        kubectl \
        libssl-dev \
        neovim \
        nodejs \
        pcscd \
        python3-dev \
        python3-pip \
        python3-setuptools \
        ripgrep \
        scdaemon
    sudo pip3 install thefuck
}

install_ubuntu_gui_dependencies()
{
    info "Setting up third party GUI repositories."
    echo "deb https://apt.enpass.io/ stable main" | sudo tee -a /etc/apt/sources.list.d/enpass.list
    curl -s https://apt.enpass.io/keys/enpass-linux.key | sudo apt-key add -
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
    echo "deb http://apt.insync.io/${ID} ${VERSION_CODENAME} non-free contrib" | sudo tee -a /etc/apt/sources.list.d/insync.list

    info "Installing Ubuntu GUI dependencies."
    sudo apt update
    # Missing packages for Ubuntu:
    #   rofi-pinentry
    sudo apt install -y \
        enpass \
        firefox \
        fonts-firacode \
        grim \
        insync \
        libwayland-dev \
        libx11-dev \
        libxcursor-dev \
        libxmu-dev \
        libxmu-headers \
        libxpm-dev \
        light \
        mako-notifier \
        neovim-qt \
        playerctl \
        rofi \
        sway \
        swaybg \
        swayidle \
        swaylock \
        waybar \
        xbitmaps 
    sudo snap install --candidate  termite
}

get_paru()
{
    info "Installing paru"
    curdir=$(pwd)
    parudir=$(mktemp -d)
    cd $parudir
    curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/paru.tar.gz | tar xzvf -
    cd paru
    makepkg -si --noconfirm
    pacman --noconfirm -U paru-*.tar.zst
    cd $curdir
}

install_arch_dependencies()
{
    info "Installing Arch prerequisites."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm base-devel curl
    get_paru
    info "Installing Arch dependencies."
    paru -S --noconfirm \
        ccid \
        fish \
        fzf \
        git \
        go \
        httpie \
        jq \
        kubectl \
        kubectx \
        neovim \
        nodejs \
        npm \
        pcsclite \
        python \
        python-pynvim \
        ripgrep \
        thefuck
}

install_arch_gui_dependencies()
{
    info "Installing Arch GUI dependencies."
    paru -S --noconfirm \
        enpass-bin \
        firefox \
        gdm \
        grim \
        insync \
        light \
        mako \
        neovim-qt  \
        otf-font-awesome \
        otf-font-awesome-4 \
        pinentry-rofi \
        playerctl \
        rofi \
        sway \
        swaybg \
        swayidle \
        swaylock \
        ttf-dejavu \
        ttf-fira-code \
        ttf-fira-sans \
        ttf-font-awesome \
        ttf-font-awesome-4 \
        ttf-joypixels \
        ttf-liberation \
        ttf-linux-libertine \
        ttf-noto-sans-kannada \
        ttf-symbola \
        ttf-twemoji \
        waybar
}

install_rust_dependencies()
{
    info "Installing rust dependencies."
    cargo install \
        exa \
        bat \
        starship \
        dust 
}

install_go_dependencies()
{
    info "Installing go dependencies."
    go get -u github.com/xyproto/wallutils/cmd/setrandom
    go get -u github.com/r00tman/corrupter
    go get -u github.com/ahmetb/kubectx/cmd/kubens
    go get -u github.com/ahmetb/kubectx/cmd/kubectx
    go get -u github.com/ainmosni/golang-gmail-check
    go get -u gihub.com/ainmosni/wayweather
}

setup_dotfiles()
{
    cd ~
    info "Cloning dotfiles in a bare repo."
    git clone --bare $HTTP_REPO $HOME/.cfg
    mkdir ~/.cfg-bck
    $GIT_CMD checkout
    if [ $? != 0 ]; then
        error "Conflicting config files found, backing up."
        for i in $($GIT_CMD checkout 2>&1 | egrep "\s+\." | awk {'print $1'}); do
            DIRNAME=$(dirname $i)
            mkdir -p "~/.cfg-bck/$DIRNAME"
            mv "$i" "~/.cfg-bck/$i"
        done
        $GIT_CMD checkout
        if [ $? != 0 ]; then
            fatal "Couldn't finish checkout of dotfiles."
        fi
    fi
    info "Completed installing dotfiles."

    info "Changing git remotes."
    $GIT_CMD remote rename origin oldorig
    $GIT_CMD remote add origin $SSH_REPO
}


while getopts 'gh' flag; do
    case "${flag}" in
        g) GUI=true ;;
        *) print_usage ;;
    esac
done

echo $GUI

detect_os
cache_sudo_password
install_dependencies
setup_dotfiles
