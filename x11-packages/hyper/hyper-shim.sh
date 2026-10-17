#!@TERMUX_PREFIX@/bin/sh

# Electron and the CLI look up xdg-open in PATH; this dir maps it to xdg-utils-xdg-open.
PATH="@TERMUX_PREFIX@/opt/hyper/bin:$PATH"
export PATH

case "${1:-}" in
	install|i|uninstall|u|rm|remove|list|ls|search|s|list-remote|lsr|ls-remote|docs|d|h|home|version|help|-h|--help)
		ELECTRON_RUN_AS_NODE=1 exec "@TERMUX_PREFIX@/bin/electron42" "@TERMUX_PREFIX@/opt/hyper/bin/cli.js" "$@"
		;;
esac

# The app only accepts absolute directory paths.
if [ -d "${1:-}" ]; then
	set -- "$(cd -- "$1" && pwd)"
fi

GDK_BACKEND="${GDK_BACKEND:-x11}" \
ELECTRON_IS_DEV=0 \
exec "@TERMUX_PREFIX@/bin/electron42" "@TERMUX_PREFIX@/opt/hyper/app" "$@"
