## my dotvim config

### Install

1. Clone this repo to .vim

    git clone https://github.com/pysnow530/dotvim.git ~/.vim

2. Install plugins

    vim +PlugInstall

### Upgrade

#### vim-8

On centos, use this command to upgrade vim to 8:

    rpm -Uvh http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm
    rpm --import http://mirror.ghettoforge.org/distributions/gf/RPM-GPG-KEY-gf.el7
    yum -y remove vim-minimal vim-common vim-enhanced sudo
    yum -y --enablerepo=gf-plus install vim-enhanced sudo

#### vim-plugin

This repo contain vim-plugin at ./autoload/plug.vim, to upgrade vim-plugin,
use the command below, and submit the upgrade to repo.

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    git add ./autoload/plug.vim
    git commit -m 'upgrade vim-plug'

