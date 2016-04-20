#!/usr/bin/env bash

# Turn comments into literal programming, including output during execution.
function reporter() {
    message="$1"
    shift
    echo
    echo "${message}"
    for (( i=0; i<${#message}; i++ )); do
        echo -n '-'
    done
    echo
}

reporter "Confirming internet connection"
if [[ ! $(curl -Is http://www.google.com/ | head -n 1) =~ "200 OK" ]]; then
  echo "Your Internet seems broken. Press Ctrl-C to abort or enter to continue."
  read
else
  echo "Connection successful"
fi

reporter "running upgrade"
sudo apt-get upgrade -y

reporter "removing bloat packages"
xargs sudo apt-get purge -y < data/bloat.list

reporter "adding dependent repos"
xargs sudo add-apt-repository < data/repos.list 
sudo apt-get update -y

reporter "installing dependendent packages"
xargs sudo apt-get -y install < data/dependencies.list

reporter "installing apt packages"
xargs sudo apt-get -y install < data/apt.list

reporter "installing pip packages"
sudo pip install -r data/pip.list

reporter "installing chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb

reporter "installing spotify"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get -y update
sudo apt-get -y install spotify-client

reporter "installing oh-my-zsh"
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

reporter "removing old config files"
old_configs=".zshrc .vimrc .vim .gitconfig"
for config in ${old_configs}; do
    rm -rf $HOME/${config}
done

reporter "cloning zsh-syntax-highlighting"
mkdir $HOME/dev; mkdir $HOME/dev/utils; cd $HOME/dev/utils
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/dev/utils

reporter "grabbing and stowing dotfiles"
dotfiles_repo=https://github.com/CullenTaylor/dotfiles.git
dotfiles_destination=$HOME
dotfiles_branch=master
stow_list="bash git htop vim zsh sounds"

git clone ${dotfiles_repo} ${dotfiles_destination}
cd ${dotfiles_destination}
git checkout ${dotfiles_branch}
for app in ${stow_list}; do
    stow ${app}
done

reporter "setting custom wallpaper"
gsettings set org.gnome.desktop.background picture-uri file:///$HOME/dotfiles/wallpaper/seattle.jpg

reporter "Generating user RSA keys"
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

echo "Done! Reboot to finish"
