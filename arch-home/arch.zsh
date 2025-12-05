eval "$(starship init zsh)"

append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

append_path '/home/john/.local/bin'
append_path '/home/john/.cargo/bin'

eval "$(/home/john/.local/bin/mise activate zsh)"

alias n=nvim
alias lg=lazygit
alias ldoc=lazydocker
alias open=xdg-open
alias cat=bat
alias hibernate="systemctl hibernate"
alias ls="eza"
alias cat="bat"

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh-plugins/zsh-vim-mode/zsh-vim-mode.plugin.zsh

eval "$(atuin init zsh)"
# Needs to be run to make qutebrowser the default browser for xdg
# BROWSER=""; xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
