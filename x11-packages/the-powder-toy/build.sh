TERMUX_PKG_HOMEPAGE=https://powdertoy.co.uk/
TERMUX_PKG_DESCRIPTION="The Powder Toy is a free physics sandbox game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=96.2.350
TERMUX_PKG_SRCURL=https://github.com/ThePowderToy/The-Powder-Toy/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d95cbadee22632687661e8fc488bd64405d81c0dca737e16420f26e93ea5bf58
TERMUX_PKG_DEPENDS="fftw, libc++, libcurl, libluajit, sdl2, zlib"
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Db_pie=true
"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin powder
	ln -sf powder $TERMUX_PREFIX/bin/the-powder-toy
}
