#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s $SCRIPT_DIR/.zshrc ~/.zshrc
ln -s $SCRIPT_DIR/.tmux.conf ~/.tmux.conf
ln -s $SCRIPT_DIR/alacritty ~/.config/alacritty
ln -s $SCRIPT_DIR/nvim ~/.config/nvim
