TERMUX_PKG_HOMEPAGE=https://nixos.org/patchelf.html
TERMUX_PKG_DESCRIPTION="Utility to modify the dynamic linker and RPATH of ELF executables"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/NixOS/patchelf/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5d1eda9bad4439bb9c0a87fcba198d7c0d372f361e77de41d68d6308062e5000
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./bootstrap.sh
}
