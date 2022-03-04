TERMUX_PKG_HOMEPAGE=gopher://gopher.quux.org/1/devel/gopher
TERMUX_PKG_DESCRIPTION="University of Minnesota gopher"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.17.3
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/universe/g/gopher/gopher_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=584b4ffeaa5221bab94bc4934b644f64df35c955e7720f3cfff648072eb0370b
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -lncursesw"
}
