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

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

set -o vi

eval "$(atuin init zsh)"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# TODO: Download this plugin
# https://github.com/softmoth/zsh-vim-mode?tab=readme-ov-file#installation

# Needs to be run to make qutebrowser the default browser for xdg
# BROWSER=""; xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
