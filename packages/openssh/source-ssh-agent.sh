#!/bin/sh
# source-ssh-agent: Script to source for ssh-agent to work
# From http://mah.everybody.org/docs/ssh

# Check if accidentaly executed instead of sourced:
if echo "$0" | grep -q source-ssh-agent; then
	echo "source-ssh-agent: Do not execute directly - source me instead!"
	exit 1
fi

SSH_ENV="$HOME/.ssh/environment"

start_agent () {
	ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	chmod 600 "${SSH_ENV}"
	. "${SSH_ENV}" > /dev/null
	ssh-add
}

if [ -f "${SSH_ENV}" ]; then
	. "${SSH_ENV}" > /dev/null
	if ps ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null; then
		# Agent already running, but it may be running without identities:
		if ssh-add -L 2> /dev/null | grep -q 'no identities'; then
			# .. in which case we add them:
			ssh-add
		fi
	else
		start_agent;
	fi
else
     start_agent;
fi
