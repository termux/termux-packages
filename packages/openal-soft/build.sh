TERMUX_PKG_HOMEPAGE=https://openal-soft.org/
TERMUX_PKG_DESCRIPTION="Software implementation of the OpenAL API"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/kcat/openal-soft/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ac17e4e3b32c1af3d5508acfffb838640669b4274606b7892aa796ca9d7467f
TERMUX_PKG_BREAKS="openal-soft-dev"
TERMUX_PKG_REPLACES="openal-soft-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DALSOFT_UTILS=ON
-DALSOFT_NO_CONFIG_UTIL=ON
-DALSOFT_EXAMPLES=ON
-DALSOFT_TESTS=OFF
-DALSOFT_REQUIRE_OPENSL=ON
"
termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DOPENSL_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libOpenSLES.so"
}
