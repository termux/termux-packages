TERMUX_PKG_HOMEPAGE=https://github.com/orhun/kermit
TERMUX_PKG_DESCRIPTION="A VTE-based simple and froggy terminal emulator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@AnGelXoG"
TERMUX_PKG_VERSION=3.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/orhun/kermit/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c0b0244841eed396ba445ccd377c9d1941d9e12300228b0129d7fc587615751e
TERMUX_PKG_DEPENDS="libvte, make, cmake"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./kermit
}
