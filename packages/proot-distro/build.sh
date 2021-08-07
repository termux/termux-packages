TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5791a1323b8c95209ce9139b8649751972463c1050fd8ea6734eae29c545f762
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, findutils, gzip, ncurses-utils, proot (>= 5.1.107-32), sed, tar, xz-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

# Allow to edit distribution plug-ins.
TERMUX_PKG_CONFFILES="
etc/proot-distro/alpine.sh
etc/proot-distro/archlinux.sh
etc/proot-distro/debian-buster.sh
etc/proot-distro/fedora-33.sh
etc/proot-distro/gentoo.sh
etc/proot-distro/ubuntu-18.04.sh
etc/proot-distro/ubuntu-20.04.sh
etc/proot-distro/ubuntu-21.04.sh
etc/proot-distro/void.s
"

termux_step_make_install() {
	TERMUX_PREFIX="$TERMUX_PREFIX" TERMUX_ANDROID_HOME="$TERMUX_ANDROID_HOME" ./install.sh
}
