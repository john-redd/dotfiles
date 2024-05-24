if [ -x "$(command -v eza)" ]; then
    alias ls="eza --icons"
    alias lt="eza --long --tree --level=2 --icons"
fi
