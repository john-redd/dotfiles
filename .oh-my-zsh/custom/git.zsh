#!/bin/zsh

alias gconflicts="git conflicts | fzf | xargs -I {} nvim {} +'/<<<<<<<'"
alias gwtrm="git worktree list | fzf | cut -w -f 1 | xargs -I {} git worktree remove {}"
