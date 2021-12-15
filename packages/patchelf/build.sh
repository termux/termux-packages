TERMUX_PKG_HOMEPAGE=https://nixos.org/patchelf.html
TERMUX_PKG_DESCRIPTION="Utility to modify the dynamic linker and RPATH of ELF executables"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14.3
TERMUX_PKG_SRCURL=https://github.com/NixOS/patchelf/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=827a8ca914c69413f1ca0d967a637980a24edf000a938531a77e663317c853bb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./bootstrap.sh
}
