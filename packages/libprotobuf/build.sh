TERMUX_PKG_HOMEPAGE=https://github.com/protocolbuffers/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
# utf8_range is licensed under MIT
TERMUX_PKG_LICENSE="BSD 3-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE
third_party/utf8_range/LICENSE
"
TERMUX_PKG_MAINTAINER="@termux"
# When bumping version:
# - update SHA256 checksum for $_PROTOBUF_ZIP in
#     $TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_protobuf.sh
# - ALWAYS bump revision of reverse dependencies and rebuild them.
TERMUX_PKG_VERSION="2:32.0"
TERMUX_PKG_SRCURL=https://github.com/protocolbuffers/protobuf/archive/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=3ad017543e502ffaa9cd1f4bd4fe96cf117ce7175970f191705fa0518aff80cd
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="abseil-cpp, libc++, zlib"
TERMUX_PKG_BREAKS="libprotobuf-dev, protobuf-static, libutf8-range"
TERMUX_PKG_REPLACES="libprotobuf-dev, protobuf-static, libutf8-range"
TERMUX_PKG_CONFLICTS="protobuf-static"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprotobuf_ABSL_PROVIDER=package
-Dprotobuf_BUILD_TESTS=OFF
-DBUILD_SHARED_LIBS=ON
-DCMAKE_INSTALL_LIBDIR=lib
"

termux_step_post_get_source() {
	# Version guard
	local ver_e=${TERMUX_PKG_VERSION#*:}
	local ver_x=$(. $TERMUX_SCRIPTDIR/packages/protobuf-static/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	if [ "${ver_e}" != "${ver_x}" ]; then
		termux_error_exit "Version mismatch between libprotobuf and protobuf-static."
	fi
}

termux_step_post_make_install() {
	# Copy lib/*.cmake to opt/protobuf-cmake/shared for future use
	mkdir -p $TERMUX_PREFIX/opt/protobuf-cmake/shared
	cp $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-targets{,-release}.cmake \
		$TERMUX_PREFIX/opt/protobuf-cmake/shared/
}
