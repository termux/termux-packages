TERMUX_PKG_HOMEPAGE=https://asymptote.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A powerful descriptive vector graphics language for technical drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.95
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/asymptote/asymptote-${TERMUX_PKG_VERSION}.src.tgz
TERMUX_PKG_SHA256=15604fd02cb6ddbc5b807529d2e6fc617c825a184dd0d7b71390c567aeac78e7
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="fftw, libc++, libtirpc, zlib, ncurses, readline"
TERMUX_PKG_BUILD_DEPENDS="glm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gc
"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin asy
	cp -rT base $TERMUX_PREFIX/share/asymptote
}
