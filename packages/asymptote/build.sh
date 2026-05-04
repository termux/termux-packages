TERMUX_PKG_HOMEPAGE=https://asymptote.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A powerful descriptive vector graphics language for technical drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.10"
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/asymptote/asymptote-${TERMUX_PKG_VERSION}.src.tgz"
TERMUX_PKG_SHA256=d27be8fef250d5dc338602bf723e1d09e8cd1e85c199ab4c80743089fd8cd2c7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, libc++, libtirpc, zlib, ncurses, readline"
TERMUX_PKG_BUILD_DEPENDS="glm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gc
--disable-lsp
"

termux_step_pre_configure() {
	rm -f CMakeLists.txt
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin asy
	cp -rT base $TERMUX_PREFIX/share/asymptote
}
