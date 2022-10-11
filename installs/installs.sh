#!/bin/sh
echo "Installing utils/software"
sudo apt-get install httpie dotnet6 vlc gimp dconf-editor curl git build-essential zsh

echo "Installing zsh and omz"
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


echo "Installing nvm/node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install stable
nvm install 16
nvm alias default 16


echo "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Setting up omz zshrc"
cp _zshrc ~/.zshrc


echo "Setting up git"
git config --global user.name "Vincenzo Ciaccio"
git config --global user.email "vincenzo.ciaccio@gmail.com"
cp _gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore
git config --global core. editor "nano"
git config --global core.editor "nano"
git config --global pager.branch false

echo "Installing Hygen Templates"
npm i -g hygen
mkdir ~/.hygen
cd ~/.hygen
git clone git@github.com:vikkio88/hygenTemplates.git _templates
cd -

echo "Setting up code dir"
mkdir ~/code

echo "Generating ssh key"
ssh-keygen -t ed25519 -C "vincenzo.ciaccio@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "dont forget to add ssh key to Github"
echo "Other things to install: VSCode, Telegram, Docker"
echo ".zshrc has golang and flutter Paths too, might want to add those"
