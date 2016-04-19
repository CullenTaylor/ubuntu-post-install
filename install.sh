#!/usr/bin/env bash

# remove bloat packages
xargs sudo apt-get purge -y < data/bloat.list

# add dependent repos
xargs sudo add-apt-repository -y < data/repos.list 
sudo apt-get update -y

# install dependencies
xargs sudo apt-get -y install < data/dependencies.list

# install apt packages
xargs sudo apt-get -y install < data/apt.list

# install pip packages
pip install -r data/pip.list

# install chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb

# install spotify 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client

# install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# remove old config files
rm -rf ~/.zshrc ~/.vimrc ~/.vim ~/.gitconfig 

# grab dotfiles and install them
dotfiles_repo=https://github.com/mctaylor/dotfiles.git
dotfiles_destination=~/dotfiles
dotfiles_branch=master
stow_list="bash git htop vim zsh sounds"

git clone ${dotfiles_repo} ${dotfiles_destination}
cd ${dotfiles_destination}
git checkout ${dotfiles_branch}

for app in ${stow_list}; do
    stow ${app}
done

sudo reboot
