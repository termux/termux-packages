TERMUX_PKG_HOMEPAGE=https://powdertoy.co.uk/
TERMUX_PKG_DESCRIPTION="The Powder Toy is a free physics sandbox game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="98.2.365"
TERMUX_PKG_SRCURL=https://github.com/ThePowderToy/The-Powder-Toy/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=21900b6b022535d0e56126b023538cc4f44b64feceafb5640492618a42a60080
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, jsoncpp, libandroid-execinfo, libbz2, libc++, libcurl, libluajit, libpng, sdl2"
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
