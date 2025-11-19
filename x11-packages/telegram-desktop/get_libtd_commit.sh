#!/usr/bin/env bash
cat $TERMUX_PKG_SRCDIR/Telegram/build/docker/centos_env/Dockerfile | awk '
/ git init td / { s = 1; }
/ git fetch / {
  if (s) {
    print;
    exit;
  }
}' | sed -E 's@.*?\s([0-9a-fA-F]{40})\s.*@\1@g'
