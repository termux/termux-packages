TERMUX_PKG_HOMEPAGE=https://github.com/badaix/snapcast
TERMUX_PKG_DESCRIPTION="A multiroom client-server audio player (server)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.34.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/badaix/snapcast/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a2918ea4d1f9b2df9c4247fd71bd452ea03a5d20ac44f60a736df90488858944
TERMUX_PKG_DEPENDS="libc++, libexpat, libflac, libogg, libopus, libsoxr, libvorbis, openssl"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBoost_INCLUDE_DIR=$TERMUX_PREFIX/include
-DANDROID_NO_TERMUX=OFF
-DBUILD_WITH_ALSA=OFF
-DBUILD_WITH_AVAHI=OFF
-DBUILD_WITH_PULSE=ON
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
