#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#nvim
ln -s ${BASEDIR}/config/nvim ~/.config/nvim

#btop
ln -s ${BASEDIR}/config/btop ~/.config/btop

#raycast
ln -s ${BASEDIR}/config/raycast ~/.config/raycast

#neofetch
ln -s ${BASEDIR}/config/neofetch ~/.config/neofetch

#gh
ln -s ${BASEDIR}/config/gh ~/.config/gh

#htop
ln -s ${BASEDIR}/config/htop ~/.config/htop

#iterm2
ln -s ${BASEDIR}/config/iterm2 ~/.config/iterm2

#Autodesk
ln -s ${BASEDIR}/config/Autodesk ~/.config/Autodesk

#zshrc
ln -s ${BASEDIR}/zshrc ~/.zshrc

#tmux.conf
ln -s ${BASEDIR}/tmux.conf ~/.tmux.conf

#zprofile
ln -s ${BASEDIR}/zprofile ~/.zprofile
