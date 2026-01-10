TERMUX_PKG_HOMEPAGE=https://powdertoy.co.uk/
TERMUX_PKG_DESCRIPTION="The Powder Toy is a free physics sandbox game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="99.3.384"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/ThePowderToy/The-Powder-Toy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d41145bd17c0a91006722bc9bd9169de4950359a305b1b97063b0fdd6edbffaa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, jsoncpp, libandroid-execinfo, libbz2, libc++, libcurl, luajit, libpng, sdl2 | sdl2-compat"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dworkaround_elusive_bzip2_lib_dir=$TERMUX_PREFIX/lib
-Dworkaround_elusive_bzip2_include_dir=$TERMUX_PREFIX/include
-Db_pie=true
-Dignore_updates=true
-Dapp_data=$TERMUX_ANDROID_HOME/.powdertoy
-Dcan_install=no
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin powder
	ln -sf powder $TERMUX_PREFIX/bin/the-powder-toy
	install -Dm700 -t $TERMUX_PREFIX/share/applications resources/powder.desktop
	install -Dm700 -T $TERMUX_PKG_SRCDIR/resources/generated_icons/icon_exe.png $TERMUX_PREFIX/share/pixmaps/powdertoy-powder.png
}
