TERMUX_PKG_HOMEPAGE=https://asymptote.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A powerful descriptive vector graphics language for technical drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.13"
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/asymptote/asymptote-${TERMUX_PKG_VERSION}.src.tgz"
TERMUX_PKG_SHA256=24b2d2fdfa1e25382c0fe84e5d79466f5ae369d7d9f8d99ee2b9b64fa11dc00c
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
