#!/bin/sh
# source-ssh-agent: Script to source for ssh-agent to work.

# Check if accidentaly executed instead of sourced:
if echo "$0" | grep -q source-ssh-agent; then
	echo "source-ssh-agent: Do not execute directly - source me instead!"
	exit 1
fi

export SSH_AUTH_SOCK=$PREFIX/tmp/ssh-agent

start_agent() {
	rm -f $SSH_AUTH_SOCK
	ssh-agent -a $SSH_AUTH_SOCK > /dev/null
	ssh-add
}

MESSAGE=$(ssh-add -L 2>&1)
if [ "$MESSAGE" = 'Could not open a connection to your authentication agent.' -o \
     "$MESSAGE" = 'Error connecting to agent: Connection refused' -o \
     "$MESSAGE" = 'Error connecting to agent: No such file or directory' ]; then
	start_agent
elif [ "$MESSAGE" = "The agent has no identities." ]; then
	ssh-add
fi
