#!/usr/bin/env bash

start_terminal_and_run_tmux() {
	osascript <<-EOF
	tell application "Ghostty"
		activate
		delay 5
    tell application "System Events" to tell process "Ghostty"
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
