TERMUX_PKG_HOMEPAGE=https://github.com/badaix/snapcast
TERMUX_PKG_DESCRIPTION="A multiroom client-server audio player (server)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.27.0
TERMUX_PKG_SRCURL=https://github.com/badaix/snapcast/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c662c6eafbaa42a4797a4ed6ba4a7602332abf99f6ba6ea88ff8ae59978a86ba
TERMUX_PKG_DEPENDS="libc++, libexpat, libflac, libopus, libsoxr, libvorbis"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
-DBUILD_TESTS=OFF
-DBoost_INCLUDE_DIR=$TERMUX_PREFIX/include
"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# Future-proof way of pretending not to be Android.
	find . -name CMakeLists.txt | xargs -n 1 \
		sed -i -E 's/if\s*\((.*\s|)ANDROID/\0_NO_TERMUX/g'
}

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
