append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

set -o vi

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^V' edit-command-line

export KEYTIMEOUT=1
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER="nvim --clean +Man!"
export TERM=xterm-256color
export CDPATH=".:..:$HOME"
export BACON_PREFS="$HOME/.config/bacon/prefs.toml"
export XDG_CONFIG_HOME="$HOME/.config"

append_path "$HOME/.local/bin"
append_path "$HOME/.cargo/bin"

alias n="nvim"
alias lg="lazygit"
alias ldoc="lazydocker"
alias ls="eza"
alias cat="bat"
alias less="moor"
alias diff="delta"

# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    source ~/mac.zsh

elif command -v pacman > /dev/null; then
    source ~/arch.zsh

else
    echo 'Unknown OS!'
fi

eval "$($HOME/.local/bin/mise activate zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
