TERMUX_PKG_HOMEPAGE=https://asymptote.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A powerful descriptive vector graphics language for technical drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.04"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/asymptote/asymptote-${TERMUX_PKG_VERSION}.src.tgz
TERMUX_PKG_SHA256=f93d27d925fd0bc333d056febe49f2d71f935844c2f8d37aecc8df0fee93c32b
TERMUX_PKG_AUTO_UPDATE=true
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
