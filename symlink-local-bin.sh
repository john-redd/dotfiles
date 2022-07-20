#!/bin/bash

for d in .local/bin/* ; do
  ln -sf "$PWD/$d" ~/.local/bin | 2>&1
done
