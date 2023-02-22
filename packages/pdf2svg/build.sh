TERMUX_PKG_HOMEPAGE=http://www.cityinthesky.co.uk/opensource/pdf2svg/
TERMUX_PKG_DESCRIPTION="A PDF to SVG converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.3
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/db9052/pdf2svg/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libcairo, poppler"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
}
