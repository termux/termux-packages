#!@TERMUX_PREFIX@/bin/sh

GDK_BACKEND="${GDK_BACKEND:-x11}" \
exec "@TERMUX_PREFIX@/bin/electron42" "@TERMUX_PREFIX@/opt/insomnia/resources/app.asar" "$@"
