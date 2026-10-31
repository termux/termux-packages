#!@TERMUX_PREFIX@/bin/sh

CHROME_DESKTOP="${CHROME_DESKTOP:-vesktop.desktop}" \
	GDK_BACKEND="${GDK_BACKEND:-x11}" \
	exec "@TERMUX_PREFIX@/bin/electron43" "@TERMUX_PREFIX@/opt/vesktop/resources/app.asar" "$@"
