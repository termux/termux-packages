#!/bin/sh
export GITEA_WORK_DIR=@TERMUX_PREFIX@/var/gitea
exec @TERMUX_PREFIX@/bin/gitea web -c @TERMUX_PREFIX@/etc/gitea/app.ini
