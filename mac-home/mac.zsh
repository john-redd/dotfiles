append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

export EDITOR='nvim'
export VISUAL='nvim'
export TERM=xterm-256color
export CDPATH=".:..:$HOME/radial:$HOME"
export MANPAGER="nvim --clean +Man!"
# export GOPRIVATE='github.com/Radial-Health'
export BACON_PREFS="$HOME/.config/bacon/prefs.toml"

append_path "$HOME/.local/bin"
append_path "$HOME/.opencode/bin"

# source <(stern --completion=zsh)
source /opt/homebrew/Cellar/zsh-syntax-highlighting/0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/Cellar/zsh-autosuggestions/0.7.1/share/zsh-autosuggestions/zsh-autosuggestions.zsh

alias n="nvim"
alias lg="lazygit"
alias ldoc="lazydocker"
alias ls="eza"
alias cat="bat"
alias less="moor"
alias diff="delta"

eval "$($HOME/.local/bin/mise activate zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
