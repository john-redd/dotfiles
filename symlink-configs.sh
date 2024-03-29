#!/bin/bash

for d in .config/* ; do
  ln -s "$PWD/$d" ~/.config > /dev/null 2>&1
done

ln -sf "$PWD/.tmux.conf" ~/ | 2>&1
ln -sf "$PWD/gruvbox-dark.conf" ~/.tmux/ | 2>&1
ln -sf "$PWD/.zshrc" ~/ | 2>&1
ln -sf "$PWD/.ideavimrc" ~/ | 2>&1
