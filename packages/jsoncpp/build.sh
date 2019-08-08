TERMUX_PKG_HOMEPAGE=https://github.com/open-source-parsers/jsoncpp
TERMUX_PKG_DESCRIPTION="C++ library for interacting with JSON"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.9.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=c7b40f5605dd972108f503f031b20186f5e5bca2b65cd4b8bd6c3e4ba8126697
TERMUX_PKG_SRCURL=https://github.com/open-source-parsers/jsoncpp/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="jsoncpp-dev"
TERMUX_PKG_REPLACES="jsoncpp-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DJSONCPP_WITH_TESTS=OFF
-DCCACHE_FOUND=OFF
"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if [ -n "$TERMUX_ON_DEVICE_BUILD" ]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# The installation does not overwrite symlinks such as libjsoncpp.so.1,
	# so if rebuilding these are not detected as modified. Fix that:
	rm -f $TERMUX_PREFIX/lib/libjsoncpp.so*
}
