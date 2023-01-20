TERMUX_PKG_HOMEPAGE=https://github.com/termux/x11-packages
TERMUX_PKG_DESCRIPTION="Package repository containing X11 programs and libraries"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
	{
		echo "# The x11 termux repository, with cloudflare cache"
		echo "deb https://packages-cf.termux.dev/apt/termux-x11/ x11 main"
		echo "# The x11 termux repository, without cloudflare cache"
		echo "# deb https://packages.termux.dev/apt/termux-x11/ x11 main"
	} > $TERMUX_PREFIX/etc/apt/sources.list.d/x11.list
}

termux_step_create_debscripts() {
	[ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] && return 0
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Downloading updated package list ..."
	if [ -d "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ] || [ -f "$TERMUX_PREFIX/etc/termux/chosen_mirrors" ]; then
		pkg --check-mirror update
	else
		apt update
	fi
	exit 0
	EOF
}
