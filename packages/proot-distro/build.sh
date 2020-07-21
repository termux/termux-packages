TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.2.1
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4f24903d9b26c42382a6b9a2576dc522aea553a3c2912e4f1c441982eb7076de
TERMUX_PKG_DEPENDS="bash, coreutils, curl, findutils, proot, tar"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

# Allow to edit distribution plug-ins.
TERMUX_PKG_CONFFILES="
etc/proot-distro/alpine.sh
etc/proot-distro/archlinux.sh
etc/proot-distro/ubuntu.sh
"

termux_step_make_install() {
	./install.sh
}
