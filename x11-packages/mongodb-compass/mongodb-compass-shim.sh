#!@TERMUX_PREFIX@/bin/sh

GDK_BACKEND="${GDK_BACKEND:-x11}" \
exec "@TERMUX_PREFIX@/bin/electron42" "@TERMUX_PREFIX@/opt/mongodb-compass/resources/app.asar" "$@"
