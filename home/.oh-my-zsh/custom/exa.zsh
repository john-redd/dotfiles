if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias lt="exa --long --tree --level=2"
fi
