#!@TERMUX_PREFIX@/bin/sh

PATH="@TERMUX_PREFIX@/opt/gdevelop/bin:$PATH" \
GDK_BACKEND="${GDK_BACKEND:-x11}" \
ELECTRON_IS_DEV=0 \
exec "@TERMUX_PREFIX@/bin/electron42" "@TERMUX_PREFIX@/opt/gdevelop/resources/app.asar" "$@"
