#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#nvim
ln -s ${BASEDIR}/config/nvim ~/.config/nvim

#zshrc
ln -s ${BASEDIR}/zshrc ~/.zshrc

#tmux.conf
ln -s ${BASEDIR}/tmux.conf ~/.tmux.conf

#zprofile
ln -s ${BASEDIR}/zprofile ~/.zprofile
