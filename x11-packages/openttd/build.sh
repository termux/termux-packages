TERMUX_PKG_HOMEPAGE=https://www.openttd.org/
TERMUX_PKG_DESCRIPTION="An engine for running Transport Tycoon Deluxe"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=13.0
TERMUX_PKG_SRCURL=https://github.com/OpenTTD/OpenTTD/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=36bc7e290c690d250354c70f9223e0504096210486be0d1bf188c74709439cda
TERMUX_PKG_DEPENDS="fontconfig, freetype, libc++, libicu, liblzma, liblzo, libpng, openttd-gfx, openttd-msx, openttd-sfx, sdl2, zlib"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBINARY_NAME=openttd
-DCMAKE_INSTALL_DATADIR=share
-DCMAKE_INSTALL_BINDIR=bin
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
-DOPTION_DEDICATED=ON
"

termux_step_host_build() {
	termux_setup_cmake
	cmake "$TERMUX_PKG_SRCDIR" $TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_pre_configure() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DHOST_BINARY_DIR=$TERMUX_PKG_HOSTBUILD_DIR"
	fi
	CXXFLAGS+=" -DU_USING_ICU_NAMESPACE=1"
}
