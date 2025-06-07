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

eval "$(/home/john/.local/bin/mise activate zsh)"
