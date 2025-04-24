#!/bin/sh

. source-ssh-agent
"${wrapped_cmd}" "$@"
