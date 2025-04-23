TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="Package repository containing X11 programs and libraries"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.5
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/etc/apt/sources.list.d"
	{ # write deb822 source entries for the x11 repo
	printf '%s\n' \
		"# The termux x11 repository, with cloudflare cache" \
		"Types: deb" \
		"URIs: https://packages-cf.termux.dev/apt/termux-x11/" \
		"Suites: x11" \
		"Components: main" \
		"Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg" \
		"" \
		"# The termux x11 repository, without cloudflare cache" \
		"#Types: deb" \
		"#URIs: https://packages.termux.dev/apt/termux-x11/" \
		"#Suites: x11" \
		"#Components: main" \
		"#Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg"
	} > "$TERMUX_PREFIX/etc/apt/sources.list.d/x11.sources"
}

termux_step_create_debscripts() {
	[[ "$TERMUX_PACKAGE_FORMAT" == 'pacman' ]] && return 0
	cat <<- EOF > ./preinst
	#!$TERMUX_PREFIX/bin/sh
	[ "\$#" -ge 2 ] || exit 0
	[ "\$1" = "install" ] || exit 0

	[ -f "$TERMUX_PREFIX/etc/apt/sources.list.d/x11.list" ] && {
		echo
		echo "================================"
		echo "Legacy repo file found for 'x11' repository."
		echo "The legacy 'sources.list.d/x11.list' entry will be migrated"
		echo "to 'sources.list.d/x11.sources' as part of the update."
		cp -vaf \\
			"$TERMUX_PREFIX"/etc/apt/sources.list.d/x11.list \\
			"$TERMUX_PREFIX"/etc/apt/sources.list.d/x11.list.dpkg-old
		echo "A backup copy of the old x11.list repo file"
		echo "has been saved to $TERMUX_PREFIX/etc/apt/sources.list.d/x11.list.dpkg-old"
		echo "================================"
		echo
	}
	exit 0
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	[ "\$1" = "configure" ] || exit 0

	[ -f "$TERMUX_PREFIX/etc/apt/sources.list.d/x11.list" ] && rm "$TERMUX_PREFIX/etc/apt/sources.list.d/x11.list"

	echo "Downloading updated package list ..."
	if [ -d "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ] || [ -f "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ]; then
		pkg --check-mirror update
	else
		apt update
	fi
	exit 0
	EOF
}
