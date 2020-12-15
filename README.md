## my dotvim config

### Install

1. Clone this repo to .vim

    git clone https://github.com/pysnow530/dotvim.git ~/.vim

2. Install plugins

    vim +PlugInstall

### Upgrade

This repo contain vim-plugin at ./autoload/plug.vim, to upgrade vim-plugin,
use the command below, and submit the upgrade to repo.

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    git add ./autoload/plug.vim
    git commit -m 'upgrade vim-plug'

