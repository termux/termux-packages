TERMUX_SUBPKG_DESCRIPTION="fcitx5 gtk2 immodule"
TERMUX_SUBPKG_INCLUDE="lib/gtk-2.0"
TERMUX_SUBPKG_DEPENDS="fcitx5, gtk2, libx11, libxkbcommon, pango"

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	"$TERMUX_PREFIX/bin/gtk-query-immodules-2.0" \
		> "$TERMUX_PREFIX/lib/gtk-2.0/2.10.0/immodules.cache"
	EOF
	cat <<- EOF > ./postrm
	#!$TERMUX_PREFIX/bin/sh
	"$TERMUX_PREFIX/bin/gtk-query-immodules-2.0" \
		> "$TERMUX_PREFIX/lib/gtk-2.0/2.10.0/immodules.cache"
	EOF
}
