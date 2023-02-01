TERMUX_SUBPKG_INCLUDE="
bin/gtk-update-icon-cache
share/man/man1/gtk-update-icon-cache.1
"

TERMUX_SUBPKG_DEPENDS="glib, gdk-pixbuf, libandroid-shmem"
TERMUX_SUBPKG_DESCRIPTION="GTK+ icon cache updater"

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
