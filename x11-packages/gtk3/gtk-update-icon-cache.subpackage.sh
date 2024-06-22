TERMUX_SUBPKG_INCLUDE="
bin/gtk-update-icon-cache
share/man/man1/gtk-update-icon-cache.1.gz
"

TERMUX_SUBPKG_DEPENDS="gdk-pixbuf, glib"
TERMUX_SUBPKG_DESCRIPTION="GTK+ icon cache updater"
TERMUX_SUBPKG_BREAKS="gtk3 (<< 3.24.41)"
TERMUX_SUBPKG_REPLACES="gtk3 (<< 3.24.41)"

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./triggers
	interest-noawait $TERMUX_PREFIX/share/icons
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	for i in \$(find "$TERMUX_PREFIX/share/icons" -type f -iname index.theme); do
		gtk-update-icon-cache --force --quiet \$(dirname "\${i}")
	done
	unset i
	exit 0
	EOF
}
