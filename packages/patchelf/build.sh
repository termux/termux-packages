TERMUX_PKG_HOMEPAGE=https://nixos.org/patchelf.html
TERMUX_PKG_DESCRIPTION="Utility to modify the dynamic linker and RPATH of ELF executables"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14.1
TERMUX_PKG_SRCURL=https://github.com/NixOS/patchelf/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9b5d6b94f2a941aca784916e5062738588a8e0d9582f599803a5fac713df537f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./bootstrap.sh
}
