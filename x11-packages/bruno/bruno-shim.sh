#!@TERMUX_PREFIX@/bin/sh

# Electron loads resources/app* next to its real binary, and code-oss ships
# VS Code there. Use a private hardlink/copy of the binary and symlink the
# shared runtime files. Redone when electron-for-code-oss is updated.
src="@TERMUX_PREFIX@/lib/code-oss"
app="@TERMUX_PREFIX@/opt/bruno"

needs_setup=false
if [ ! -x "$app/bruno-bin" ]; then
	needs_setup=true
elif [ -n "$(find "$src/code-oss" -newer "$app/bruno-bin" 2>/dev/null)" ]; then
	needs_setup=true
fi

if [ "$needs_setup" = true ]; then
	rm -f "$app/bruno-bin"
	ln "$src/code-oss" "$app/bruno-bin" 2>/dev/null || cp "$src/code-oss" "$app/bruno-bin" || exit 1
	for f in "$src"/*; do
		case "${f##*/}" in
			code-oss|resources|bin|node_headers) continue ;;
		esac
		ln -sf "$f" "$app/${f##*/}"
	done
fi

export GDK_BACKEND="${GDK_BACKEND:-x11}"
export WEBKIT_DISABLE_COMPOSITING_MODE="${WEBKIT_DISABLE_COMPOSITING_MODE:-1}"

# Like code-oss, detach from the caller so launching from a menu or a
# bruno:// URL handler works. Set BRUNO_FOREGROUND=1 to keep it attached.
if [ -n "${BRUNO_FOREGROUND:-}" ]; then
	exec "$app/bruno-bin" "$@"
fi
"$app/bruno-bin" "$@" >/dev/null 2>&1 </dev/null &
