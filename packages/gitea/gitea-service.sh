#!/bin/sh

PREFIX=@TERMUX_PREFIX@
export GITEA_WORK_DIR=${PREFIX}/var/gitea
export USER=`whoami`

${PREFIX}/bin/gitea web -c ${PREFIX}/etc/gitea/app.ini
