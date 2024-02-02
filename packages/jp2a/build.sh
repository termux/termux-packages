TERMUX_PKG_HOMEPAGE=https://csl.name/jp2a/
TERMUX_PKG_DESCRIPTION="A simple JPEG to ASCII converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://github.com/Talinx/jp2a/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a19088bb4ba27e8a5524f26f0f1622529ca087e36f5a060c6535c11b266106d1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libjpeg-turbo, libpng, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vi
}
