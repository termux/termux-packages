#!@TERMUX_PREFIX@/bin/sh

GDK_BACKEND="${GDK_BACKEND:-x11}" \
NODE_ENV=production \
exec "@TERMUX_PREFIX@/bin/electron42" "@TERMUX_PREFIX@/opt/logseq/resources/app.asar" "$@"
