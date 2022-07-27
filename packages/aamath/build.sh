TERMUX_PKG_HOMEPAGE="https://github.com/gchudnov/aamath"
TERMUX_PKG_DESCRIPTION="Renders mathematical expressions as ASCII art"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3"
TERMUX_PKG_SRCURL="https://github.com/gchudnov/aamath/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b1354c0ad6ad9f0b2a941833fbbce142f3c5b0170f7f551ed5630193d5e15d8a
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_MAKE_ARGS="DESTDIR=$TERMUX_PREFIX/bin VERBOSE=1"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		$TERMUX_PKG_SRCDIR/aamath.1
}
