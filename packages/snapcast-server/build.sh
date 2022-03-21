TERMUX_PKG_HOMEPAGE=https://github.com/badaix/snapcast
TERMUX_PKG_DESCRIPTION="A multiroom client-server audio player (server)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.25.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/badaix/snapcast/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c4e449cb693e091261727421f4965492be049632537e034fa9c59c92d091a846
TERMUX_PKG_DEPENDS="libc++, libexpat, libflac, libopus, libsoxr, libvorbis"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DBoost_INCLUDE_DIR=$TERMUX_PREFIX/include
"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
