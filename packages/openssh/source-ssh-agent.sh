#!/bin/sh
# source-ssh-agent: Script to source for ssh-agent to work.

start_agent() {
	ssh-agent -a "$1" > /dev/null
	ssh-add
}

# Allow overriding the start_agent function easily.
if [ -r "${PREFIX}/etc/ssh/start_agent.sh" ]; then
	. "${PREFIX}/etc/ssh/start_agent.sh"
fi

export SSH_AUTH_SOCK="${PREFIX}/var/run/ssh-agent"

MESSAGE=$(ssh-add -L 2>&1)
if [ "$MESSAGE" = 'Could not open a connection to your authentication agent.' -o \
     "$MESSAGE" = 'Error connecting to agent: Connection refused' -o \
     "$MESSAGE" = 'Error connecting to agent: No such file or directory' ]; then
	rm -f "${SSH_AUTH_SOCK}"
	start_agent "${SSH_AUTH_SOCK}"
elif [ "$MESSAGE" = "The agent has no identities." ]; then
	ssh-add
fi
