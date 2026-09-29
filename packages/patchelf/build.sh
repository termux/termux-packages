TERMUX_PKG_HOMEPAGE=https://nixos.org/patchelf.html
TERMUX_PKG_DESCRIPTION="Utility to modify the dynamic linker and RPATH of ELF executables"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.19.2"
TERMUX_PKG_SRCURL=https://github.com/NixOS/patchelf/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=05e674fcc89ef3ffbd851266d063f45f13bd16facec9839a54d0095b930c6f07
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./bootstrap.sh
}
