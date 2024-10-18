TERMUX_PKG_HOMEPAGE=https://wvware.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A library which allows access to Microsoft Word files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.9
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/old/wv-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d
TERMUX_PKG_DEPENDS="glib, libgsf, libpng, libxml2, zlib"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
