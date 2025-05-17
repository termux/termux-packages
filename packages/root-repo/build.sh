TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="Package repository containing programs for rooted devices"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.5
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/etc/apt/sources.list.d"
	{ # write deb822 source entries for the root repo
	printf '%s\n' \
		"# The termux root repository, with cloudflare cache" \
		"Types: deb" \
		"URIs: https://packages-cf.termux.dev/apt/termux-root/" \
		"Suites: root" \
		"Components: stable" \
		"Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg" \
		"" \
		"# The termux root repository, without cloudflare cache" \
		"#Types: deb" \
		"#URIs: https://packages.termux.dev/apt/termux-root/" \
		"#Suites: root" \
		"#Components: stable" \
		"#Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg"
	} > "$TERMUX_PREFIX/etc/apt/sources.list.d/root.sources"
}

termux_step_create_debscripts() {
	[[ "$TERMUX_PACKAGE_FORMAT" == 'pacman' ]] && return 0
	cat <<- EOF > ./preinst
	#!$TERMUX_PREFIX/bin/sh
	[ "\$#" -ge 2 ] || exit 0
	[ "\$1" = "install" ] || exit 0

	[ -f "$TERMUX_PREFIX/etc/apt/sources.list.d/root.list" ] && {
		echo
		echo "================================"
		echo "Legacy repo file found for 'root' repository."
		echo "The legacy 'sources.list.d/root.list' entry will be migrated"
		echo "to 'sources.list.d/root.sources' as part of the update."
		cp -vaf \\
			"$TERMUX_PREFIX"/etc/apt/sources.list.d/root.list \\
			"$TERMUX_PREFIX"/etc/apt/sources.list.d/root.list.dpkg-old
		echo "A backup copy of the old root.list repo file"
		echo "has been saved to $TERMUX_PREFIX/etc/apt/sources.list.d/root.list.dpkg-old"
		echo "================================"
		echo
	}
	exit 0
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	[ "\$1" = "configure" ] || exit 0

	[ -f "$TERMUX_PREFIX/etc/apt/sources.list.d/root.list" ] && rm "$TERMUX_PREFIX/etc/apt/sources.list.d/root.list"

	echo "Downloading updated package list ..."
	if [ -d "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ] || [ -f "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ]; then
		pkg --check-mirror update
	else
		apt update
	fi
	exit 0
	EOF
}
