TERMUX_PKG_HOMEPAGE=https://powdertoy.co.uk/
TERMUX_PKG_DESCRIPTION="The Powder Toy is a free physics sandbox game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=97.0.352
TERMUX_PKG_SRCURL=https://github.com/ThePowderToy/The-Powder-Toy/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3ab27e1b9a84db1da7342e61232ad5be981ca1ddf001c4924fd08b61cc8d287a
TERMUX_PKG_DEPENDS="fftw, jsoncpp, libbz2, libc++, libcurl, libluajit, libpng, sdl2"
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dworkaround_elusive_bzip2_lib_dir=$TERMUX_PREFIX/lib
-Dworkaround_elusive_bzip2_include_dir=$TERMUX_PREFIX/include
-Db_pie=true
"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin powder
	ln -sf powder $TERMUX_PREFIX/bin/the-powder-toy
}
