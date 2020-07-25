TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f5cad93df6f61ffceba9779a3a8fc1b4319635c1d8c9f1e9a0dbc67ed29f57fe
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, findutils, gzip, ncurses-utils, proot, tar, xz-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

# Allow to edit distribution plug-ins.
TERMUX_PKG_CONFFILES="
etc/proot-distro/alpine.sh
etc/proot-distro/archlinux.sh
etc/proot-distro/nethunter.sh
etc/proot-distro/ubuntu.sh
"

termux_step_make_install() {
	./install.sh
}
