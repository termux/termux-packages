TERMUX_PKG_HOMEPAGE=https://github.com/open-source-parsers/jsoncpp
TERMUX_PKG_DESCRIPTION="C++ library for interacting with JSON"
TERMUX_PKG_VERSION=1.8.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=c49deac9e0933bcb7044f08516861a2d560988540b23de2ac1ad443b219afdb6
TERMUX_PKG_SRCURL=https://github.com/open-source-parsers/jsoncpp/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DJSONCPP_WITH_TESTS=OFF
-DCCACHE_FOUND=OFF
"

termux_step_pre_configure () {
	# The installation does not overwrite symlinks such as libjsoncpp.so.1,
	# so if rebuilding these are not detected as modified. Fix that:
	rm -f $TERMUX_PREFIX/lib/libjsoncpp.so*
}
