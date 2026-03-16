#!/bin/bash

TERMUX_PKG_HOMEPAGE="https://github.com/anbuinfosec/pixiewps-extend"
TERMUX_PKG_DESCRIPTION="WPS pixie-dust attack tool with worldwide router database"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@anbuinfosec <anbuinfosec@gmail.com>"
TERMUX_PKG_VERSION=1.4.3
TERMUX_PKG_SRCURL="https://github.com/anbuinfosec/pixiewps-extend/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="36cd8eafbd3932a8c3dfacc7abb35a6b0b3540c4058a775bb1216c14fd2ba45c"
TERMUX_PKG_DEPENDS="cmake, make, clang"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		.
}

termux_step_make() {
	cmake --build . --config Release
}

termux_step_make_install() {
	install -Dm755 build/pixiewps-1.2 $TERMUX_PREFIX/bin/pixiewps
	install -Dm644 README.md $TERMUX_PREFIX/share/doc/pixiewps/README.md
	install -Dm644 CHANGELOG.md $TERMUX_PREFIX/share/doc/pixiewps/CHANGELOG.md
	install -Dm644 LICENSE.md $TERMUX_PREFIX/share/doc/pixiewps/LICENSE.md
}
