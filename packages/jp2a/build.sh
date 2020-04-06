TERMUX_PKG_HOMEPAGE=https://csl.name/jp2a/
TERMUX_PKG_DESCRIPTION="A simple JPEG to ASCII converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.9
TERMUX_PKG_SRCURL=https://github.com/Talinx/jp2a/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=180790d4dae5dc5ac4b028531dc3905a1b1aa39a6a83ce145420026223d37b88
TERMUX_PKG_DEPENDS="libcurl, libjpeg-turbo, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vi
}
