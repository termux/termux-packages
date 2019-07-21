if [ -x @TERMUX_PREFIX@/libexec/termux/command-not-found ]; then
	command_not_found_handle() {
		@TERMUX_PREFIX@/libexec/termux/command-not-found "$1"
	}
fi

PS1='\$ '
