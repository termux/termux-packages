TERMUX_PKG_HOMEPAGE=https://github.com/badaix/snapcast
TERMUX_PKG_DESCRIPTION="A multiroom client-server audio player (server)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.32.2"
TERMUX_PKG_SRCURL=https://github.com/badaix/snapcast/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=881173321f5fc929319d31b5063d91a25187e61e984cdb85e57266ea5e2b3f7f
TERMUX_PKG_DEPENDS="libc++, libexpat, libflac, libogg, libopus, libsoxr, libvorbis, openssl"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBoost_INCLUDE_DIR=$TERMUX_PREFIX/include
-DANDROID_NO_TERMUX=OFF
-DBUILD_WITH_AVAHI=OFF
-DBUILD_TESTS=OFF
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
