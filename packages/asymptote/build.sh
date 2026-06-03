TERMUX_PKG_HOMEPAGE=https://asymptote.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A powerful descriptive vector graphics language for technical drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.12"
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/asymptote/asymptote-${TERMUX_PKG_VERSION}.src.tgz"
TERMUX_PKG_SHA256=eaec1e97463ef213a393c388d466a73478b0818f9403c962b91240659c9b8f1b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, libc++, libcurl, libtirpc, zlib, ncurses, readline"
TERMUX_PKG_BUILD_DEPENDS="eigen, glm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gc
--disable-gl
--disable-lsp
--disable-vulkan
"

termux_step_pre_configure() {
	rm -f CMakeLists.txt
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" asy
	cp -rT base "$TERMUX_PREFIX/share/asymptote"
}
