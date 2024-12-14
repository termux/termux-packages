#!/bin/bash
if ! command -v tmux &>/dev/null; then
    echo "Tmux is not installed. Installing tmux..."
    apt-get install tmux
fi
