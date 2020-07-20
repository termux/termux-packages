TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v0.1.tar.gz
TERMUX_PKG_SHA256=bf58e46a97fd2b98b8c48311acedf794f7618d0921834c0c6d8644c246665d04
TERMUX_PKG_DEPENDS="bash, coreutils, proot, tar"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	./install.sh
}
