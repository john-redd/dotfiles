#!/bin/bash

for d in .config/* ; do
  ln -s "$PWD/$d" ~/.config | 2>&1
done

ln -s "$PWD/.tmux.conf" ~/ | 2>&1
ln -s "$PWD/.zshrc" ~/ | 2>&1
