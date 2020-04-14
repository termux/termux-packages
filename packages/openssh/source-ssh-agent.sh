#!/bin/sh
# source-ssh-agent: Script to source for ssh-agent to work.

export SSH_AUTH_SOCK=$PREFIX/var/run/ssh-agent

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
