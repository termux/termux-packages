#!@TERMUX_PREFIX@/bin/sh

# Electron calls plain "xdg-open"; Termux ships it as "xdg-utils-xdg-open",
# so put a symlink dir first in PATH.
PATH="@TERMUX_PREFIX@/opt/drawio/bin:$PATH" \
GDK_BACKEND="${GDK_BACKEND:-x11}" \
exec "@TERMUX_PREFIX@/bin/electron42" "@TERMUX_PREFIX@/opt/drawio/resources/app.asar" "$@"
