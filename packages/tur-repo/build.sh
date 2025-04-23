TERMUX_PKG_HOMEPAGE=https://github.com/termux-user-repository/tur
TERMUX_PKG_DESCRIPTION="A single and trusted place for all unofficial/less popular termux packages"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/etc/apt/sources.list.d"
	{ # write deb822 source entries for the TUR repo
	printf '%s\n' \
		"# A single and trusted place for all unofficial/less popular termux packages" \
		"Types: deb" \
		"URIs: https://tur.kcubeterm.com/" \
		"Suites: tur-packages" \
		"Components: tur tur-on-device tur-continuous" \
		"Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/tur.gpg"
	} > "$TERMUX_PREFIX/etc/apt/sources.list.d/tur.sources"
	## tur gpg key
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/tur.gpg" "$TERMUX_PREFIX/etc/apt/trusted.gpg.d/"
}

termux_step_create_debscripts() {
	[[ "$TERMUX_PACKAGE_FORMAT" == 'pacman' ]] && return 0
	cat <<- EOF > ./preinst
	#!$TERMUX_PREFIX/bin/sh
	[ "\$#" -ge 2 ] || exit 0
	[ "\$1" = "install" ] || exit 0

	[ -f "$TERMUX_PREFIX/etc/apt/sources.list.d/tur.list" ] && {
		echo
		echo "================================"
		echo "Legacy repo file found for 'tur' repository."
		echo "The legacy 'sources.list.d/tur.list' entry will be migrated"
		echo "to 'sources.list.d/tur.sources' as part of the update."
		cp -vaf \\
			"$TERMUX_PREFIX"/etc/apt/sources.list.d/tur.list \\
			"$TERMUX_PREFIX"/etc/apt/sources.list.d/tur.list.dpkg-old
		echo "A backup copy of the old tur.list repo file"
		echo "has been saved to $TERMUX_PREFIX/etc/apt/sources.list.d/tur.list.dpkg-old"
		echo "================================"
		echo
	}
	exit 0
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	[ "\$1" = "configure" ] || exit 0

	[ -f "$TERMUX_PREFIX/etc/apt/sources.list.d/tur.list" ] && rm "$TERMUX_PREFIX/etc/apt/sources.list.d/tur.list"

	echo "Downloading updated package list ..."
	if [ -d "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ] || [ -f "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ]; then
		pkg --check-mirror update
	else
		apt update
	fi
	exit 0
	EOF
}
