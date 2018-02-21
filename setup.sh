#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)

sudo yum install -y vim
sudo yum install git gcc-c++ make openssl-devel
git clone https://github.com/creationix/nvm.git ~/.nvm

cp .bashrc .vimrc ~/



