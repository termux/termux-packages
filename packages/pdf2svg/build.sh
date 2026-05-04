TERMUX_PKG_HOMEPAGE=http://www.cityinthesky.co.uk/opensource/pdf2svg/
TERMUX_PKG_DESCRIPTION="A PDF to SVG converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/db9052/pdf2svg/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=fd765256f18b5890639e93cabdf631b640966ed1ea9ebd561aede9d3be2155e4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libcairo, poppler"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
}
