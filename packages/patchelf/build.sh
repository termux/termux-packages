TERMUX_PKG_HOMEPAGE=https://nixos.org/patchelf.html
TERMUX_PKG_DESCRIPTION="Utility to modify the dynamic linker and RPATH of ELF executables"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.19.0"
TERMUX_PKG_SRCURL=https://github.com/NixOS/patchelf/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cbcabe6e2e00d930ef882d8aa4fafe0183133b24827700d4a0a72b886cc265b3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./bootstrap.sh
}
