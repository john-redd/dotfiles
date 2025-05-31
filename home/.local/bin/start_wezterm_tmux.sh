#!/usr/bin/env bash

start_terminal_and_run_tmux() {
	osascript <<-EOF
	tell application "WezTerm"
		activate
		delay 1
    tell application "System Events" to tell process "WezTerm"
			set frontmost to true
			keystroke "tmux"
			key code 36
		end tell
	end tell
	EOF
}

main() {
	start_terminal_and_run_tmux
}
main
