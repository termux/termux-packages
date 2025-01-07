TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/xboard/
TERMUX_PKG_DESCRIPTION="A graphical chessboard for the X Window System"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.9.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/xboard/xboard-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6
TERMUX_PKG_DEPENDS="glib, libcairo, librsvg, libx11, libxaw, libxmu, libxt, pango"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-gtk
"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
}
