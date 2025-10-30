echo "Setting up git"
git config --global user.name "Vincenzo Ciaccio"
git config --global user.email "vincenzo.ciaccio@gmail.com"
cp _gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore
git config --global core.editor "nano"
git config --global pager.branch false
git config --global init.defaultBranch main