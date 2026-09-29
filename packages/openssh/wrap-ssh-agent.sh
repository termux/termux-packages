#!/bin/sh

. "${TERMUX__PREFIX:-"${PREFIX}"}"/libexec/source-ssh-agent.sh
"${wrapped_cmd}" "$@"
