#!/bin/sh
# source-ssh-agent: Script to source for ssh-agent to work.

start_agent() {
	ssh-agent -a "$1" > /dev/null
	ssh-add
}

# Allow overriding the start_agent function easily.
if [ -r "${TERMUX__PREFIX:-"${PREFIX}"}"/etc/ssh/start_agent.sh ]; then
	. "${TERMUX__PREFIX:-"${PREFIX}"}"/etc/ssh/start_agent.sh
fi

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-"${TERMUX__PREFIX:-"${PREFIX}"}/var/run"}"/ssh-agent.socket

MESSAGE=$(ssh-add -L 2>&1)
if [ "$MESSAGE" = 'Could not open a connection to your authentication agent.' -o \
     "$MESSAGE" = 'Error connecting to agent: Connection refused' -o \
     "$MESSAGE" = 'Error connecting to agent: No such file or directory' ]; then
	rm -f "${SSH_AUTH_SOCK}"
	start_agent "${SSH_AUTH_SOCK}"
elif [ "$MESSAGE" = "The agent has no identities." ]; then
	ssh-add
fi

# may be used by wrapper scripts:
# . /path/to/source-ssh-agent.sh
# "${wrapped_cmd}" "$@"
_arg_zero="${0##*/}"
wrapped_cmd="${_arg_zero%a}"
unset -v _arg_zero
