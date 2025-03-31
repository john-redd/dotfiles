if [ -x "$(command -v eza)" ]; then
  alias ls='eza --color=always --group-directories-first --icons=always'
  alias ll='eza -la --icons=always --octal-permissions --group-directories-first'
  alias l='eza -bGF --header --git --color=always --group-directories-first --icons=always'
  alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons=always'
  alias la='eza --long --all --group --group-directories-first'
  alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons=always'

  alias lS='eza -1 --color=always --group-directories-first --icons=always'
  alias lt='eza --tree --level=2 --color=always --group-directories-first --icons=always'
  alias l.="eza -a | grep -E '^\.'"
fi
