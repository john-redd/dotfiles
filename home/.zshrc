# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    source ./mac.zsh

elif command -v pacman > /dev/null; then
    source ./arch.zsh

else
    echo 'Unknown OS!'
fi
