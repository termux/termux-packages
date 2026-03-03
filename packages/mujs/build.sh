TERMUX_PKG_HOMEPAGE=https://mujs.com/
TERMUX_PKG_DESCRIPTION="A lightweight Javascript interpreter designed for embedding in other software"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.9"
TERMUX_PKG_SRCURL="https://mujs.com/downloads/mujs-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=956d5a20dd4efe5aa58673558787b9e2539255f9bf62585e90e1921fa040d89d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="HAVE_READLINE=yes"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}
