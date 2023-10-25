TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=96c5a7979c25d81411e538e46ab08701c9653f18777f0650eab02e374a4b8ff3
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, findutils, gzip, ncurses-utils, proot (>= 5.1.107-32), sed, tar, termux-tools, xz-utils"
TERMUX_PKG_SUGGESTS="termux-api"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	env TERMUX_APP_PACKAGE="$TERMUX_APP_PACKAGE" \
		TERMUX_PREFIX="$TERMUX_PREFIX" \
		TERMUX_ANDROID_HOME="$TERMUX_ANDROID_HOME" \
		./install.sh
}

termux_step_create_debscripts() {
	# Distribution manjaro-aarch64 renamed to manjaro
	cat <<- EOF > ./preinst
	#!${TERMUX_PREFIX}/bin/bash
	set -e
	if [ -e "${TERMUX_PREFIX}/etc/proot-distro/manjaro-aarch64.sh" ] && \
		[ -e "${TERMUX_PREFIX}/var/lib/proot-distro/installed-rootfs/manjaro-aarch64" ] && \
		! [ -e "${TERMUX_PREFIX}/etc/proot-distro/manjaro.sh" ] && \
		! [ -e "${TERMUX_PREFIX}/var/lib/proot-distro/installed-rootfs/manjaro" ]; then

		mv "${TERMUX_PREFIX}/etc/proot-distro/manjaro-aarch64.sh" \
			"${TERMUX_PREFIX}/etc/proot-distro/manjaro.sh"

		mv "${TERMUX_PREFIX}/var/lib/proot-distro/installed-rootfs/manjaro-aarch64" \
			"${TERMUX_PREFIX}/var/lib/proot-distro/installed-rootfs/manjaro"

		echo "PRoot-Distro upgrade note: the distribution manjaro-aarch64 now available as manjaro."
	fi
	EOF
}
