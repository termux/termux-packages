TERMUX_SUBPKG_DESCRIPTION="fcitx5 gtk3 immodule"
TERMUX_SUBPKG_INCLUDE="lib/gtk-3.0"
TERMUX_SUBPKG_DEPENDS="fcitx5, gdk-pixbuf, gtk3, libc++, libcairo, libx11, libxkbcommon, pango"

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	"$TERMUX_PREFIX/bin/gtk-query-immodules-3.0" \
		> "$TERMUX_PREFIX/lib/gtk-3.0/3.0.0/immodules.cache"
	EOF
	cat <<- EOF > ./postrm
	#!$TERMUX_PREFIX/bin/sh
	"$TERMUX_PREFIX/bin/gtk-query-immodules-3.0" \
		> "$TERMUX_PREFIX/lib/gtk-3.0/3.0.0/immodules.cache"
	EOF
}
