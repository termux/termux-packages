TERMUX_PKG_HOMEPAGE=http://htmlcxx.sourceforge.net
TERMUX_PKG_DESCRIPTION="simple HTML/CSS1 parser library for C++"
TERMUX_PKG_VERSION=0.86
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/htmlcxx/files/htmlcxx/$TERMUX_PKG_VERSION/htmlcxx-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=07542b5ea2442143b125ba213b6823ff4a23fff352ecdd84bbebe1d154f4f5c1
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
termux_step_pre_configure() {
	autoreconf -if
}
