TERMUX_PKG_HOMEPAGE=https://github.com/termux/glibc-packages
TERMUX_PKG_DESCRIPTION="A package repository containing glibc-based programs and libraries"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux-pacman"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/etc/apt/sources.list.d"
	{ # write deb822 source entries for the x11 repo
	printf '%s\n' \
		"# The termux glibc repository, with cloudflare cache" \
		"Types: deb" \
		"URIs: https://packages-cf.termux.dev/apt/termux-glibc/" \
		"Suites: glibc" \
		"Components: stable" \
		"Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg" \
		"" \
		"# The termux glibc repository, without cloudflare cache" \
		"#Types: deb" \
		"#URIs: https://packages.termux.dev/apt/termux-glibc/" \
		"#Suites: glibc" \
		"#Components: stable" \
		"#Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg"
	} > "$TERMUX_PREFIX/etc/apt/sources.list.d/glibc.sources"
}

termux_step_create_debscripts() {
	[[ "$TERMUX_PACKAGE_FORMAT" == 'pacman' ]] && return 0
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	[ -f "$TERMUX_PREFIX/etc/apt/sources.list.d/glibc.list" ] && {
		echo "Legacy repo file found for 'glibc' repository."
		echo "Migrating sources.list.d/glibc.list to sources.list.d/glibc.sources"
		mv -v "$TERMUX_PREFIX"/etc/apt/sources.list.d/glibc.list{,.dpkg-old}
		echo "A backup copy of the old glibc.list repo file"
		echo "has been saved to $TERMUX_PREFIX/etc/apt/sources.list.d/glibc.list.dpkg-old"
	}

	echo "Downloading updated package list ..."
	if [ -d "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ] || [ -f "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ]; then
		pkg --check-mirror update
	else
		apt update
	fi
	exit 0
	EOF
}
