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

export ENABLE_WAL=false

if [[ "$TERM_PROGRAM" != "tmux" && "$ENABLE_WAL" == "true" ]] then
  # Import colorscheme from 'wal' asynchronously
  # &   # Run the process in the background.
  # ( ) # Hide shell job control messages.
  # Not supported in the "fish" shell.
  (cat ~/.cache/wal/sequences &)

  # To add support for TTYs this line can be optionally added.
  source ~/.cache/wal/colors-tty.sh
  source ~/.cache/wal/colors.sh
fi

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
