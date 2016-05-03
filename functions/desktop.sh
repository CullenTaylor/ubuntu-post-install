#!/usr/bin/env bash

###############################################################################
##                   -------------------------------                         ##
##                   | Install on Desktop Function |                         ##
##                   -------------------------------                         ##
## Function to install Ubuntu Gnome environment to desktop machine           ##
##                                                                           ##
###############################################################################

set -x

function install-on-desktop() {
    INSTALL_DIR=$1
    source ${INSTALL_DIR}/functions/reporter.sh

    reporter "Checking for curl"
    if [[ $(dpkg-query -W -f='${Status}' curl 2>/dev/null \
          | grep -c "ok installed")                       \
          -eq 0 ]]; then
              sudo apt-get -y install curl;
    fi

    check-connection 
    
    reporter "running upgrade"
    sudo apt-get upgrade -y
    
    reporter "removing bloat packages"
    xargs sudo apt-get purge -y < $INSTALL_DIR/data/bloat.list
    
    reporter "adding dependent repos"
    xargs sudo add-apt-repository < $INSTALL_DIR/data/repos.list 
    sudo apt-get update -y
    
    reporter "installing dependendent packages"
    xargs sudo apt-get -y install < $INSTALL_DIR/data/dependencies.list
    
    reporter "installing apt packages"
    xargs sudo apt-get -y install < $INSTALL_DIR/data/apt.list
    
    reporter "installing pip packages"
    sudo pip install -r $INSTALL_DIR/data/pip.list
    
    reporter "installing chrome"
    wget -P  \
        /tmp \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i /tmp/google-chrome*.deb
    
    reporter "installing spotify"
    sudo apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
    echo \
        deb http://repository.spotify.com stable non-free \
        | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get -y update && sudo apt-get -y install spotify-client
    
    reporter "installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    
    reporter "removing old config files"
    old_configs=".zshrc .vimrc .vim .gitconfig"
    for config in ${old_configs}; do
        rm -rf $HOME/${config}
    done
    
    reporter "cloning zsh-syntax-highlighting"
    mkdir $HOME/dev; mkdir $HOME/dev/utils; 
    syntax_dir=$HOME/dev/utils/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${syntax_dir} 
    
    reporter "grabbing and stowing dotfiles"
    dotfiles_repo=https://github.com/CullenTaylor/dotfiles.git
    dotfiles_destination=$HOME/dotfiles
    dotfiles_branch=master
    stow_list="bash git htop vim zsh sounds"
    
    git clone ${dotfiles_repo} ${dotfiles_destination} 
    cd ${dotfiles_destination}
    git checkout ${dotfiles_branch}
    for app in ${stow_list}; do
        stow ${app}
    done
    cd ${HOME}
    
    reporter "installing PIA"
    wget -P /tmp https://www.privateinternetaccess.com/installer/install_ubuntu.sh
    sudo sh ./tmp/install_ubuntu.sh
    
    reporter "setting custom wallpaper"
    gsettings set org.gnome.desktop.background picture-uri file:///$HOME/dotfiles/wallpaper/seattle.jpg
    
    reporter "Generating user RSA keys"
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    
    reporter "Cleaning up..."
    rm /tmp/google-chrome*.deb
    rm /tmp/install_ubuntu.sh
    
    echo "Done! Reboot to finish"
}
