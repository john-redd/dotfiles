#!/bin/bash

for d in .oh-my-zsh/custom/* ; do
  ln -sf "$PWD/$d" ~/.oh-my-zsh/custom | 2>&1
done
