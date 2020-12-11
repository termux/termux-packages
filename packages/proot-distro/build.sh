TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b9bdb6b91e954c5f14a68301d3475861a1c9a9e62b3a394a979094805952db69
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, findutils, gzip, ncurses-utils, proot (>= 5.1.107-32), sed, tar, xz-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

# Allow to edit distribution plug-ins.
TERMUX_PKG_CONFFILES="
etc/proot-distro/alpine.sh
etc/proot-distro/archlinux.sh
etc/proot-distro/debian-buster.sh
etc/proot-distro/nethunter.sh
etc/proot-distro/ubuntu-18.04.sh
etc/proot-distro/ubuntu-20.04.sh
"

termux_step_make_install() {
	./install.sh
}
