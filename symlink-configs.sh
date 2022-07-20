#!/bin/bash

for d in .config/* ; do
  ln -s "$PWD/$d" ~/.config | 2>&1
done

ln -sf "$PWD/.tmux.conf" ~/ | 2>&1
ln -sf "$PWD/.zshrc" ~/ | 2>&1
