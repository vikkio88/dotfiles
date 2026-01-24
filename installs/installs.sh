#!/bin/sh
echo "Installing utils/software"
sudo apt-get install vlc gimp curl git build-essential zsh fonts-firacode blueman xfce4-xkb-plugin albert ristretto imagemagick mugshot vim xarchiver

echo "Installing zsh and omz"
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


echo "Installing nvm/node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bas
nvm install stable


echo "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Setting up omz zshrc"
cp _zshrc ~/.zshrc

echo "Installing Ruetta Templates"
cargo install ruetta
git clone git@github.com:vikkio88/ruetta_templates.git ~/.ruetta_tmpl
cd -
ruetta init

echo "Installing dev tools"
npm i -g ntrallazzu tinchi

echo "Setting up code dir"
mkdir ~/code

echo "Generating ssh key"
ssh-keygen -t ed25519 -C "vincenzo.ciaccio@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "dont forget to add ssh key to Github"
echo "Other things to install: Zed, Telegram, Docker"
echo ".zshrc has golang, zig Paths too, might want to add those"
