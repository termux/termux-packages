TERMUX_PKG_HOMEPAGE=https://github.com/protocolbuffers/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library (static)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# Please align the version with `libprotobuf` package.
TERMUX_PKG_VERSION=30.0
TERMUX_PKG_SRCURL=https://github.com/protocolbuffers/protobuf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9df0e9e8ebe39f4fbbb9cf7db3d811287fe3616b2f191eb2bf5eaa12539c881f
v_proto_version_shared=$(. $TERMUX_SCRIPTDIR/packages/libprotobuf/build.sh; echo ${TERMUX_PKG_VERSION})
v_proto_version_revision=$(TERMUX_PKG_REVISION=0; . $TERMUX_SCRIPTDIR/packages/libprotobuf/build.sh; echo ${TERMUX_PKG_REVISION})
v_proto_extract_version="${v_proto_version_shared}-${v_proto_version_revision}"
if [ "$v_proto_version_revision" = 0 ]; then
	v_proto_extract_version="${v_proto_version_shared}"
fi
TERMUX_PKG_DEPENDS="abseil-cpp, protobuf (= ${v_proto_extract_version})"
unset v_proto_version_shared v_proto_version_revision v_proto_extract_version
TERMUX_PKG_BUILD_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="libprotobuf (<< 2:21.12)"
TERMUX_PKG_REPLACES="libprotobuf (<< 2:21.12)"
TERMUX_PKG_CONFLICTS="protobuf-dev"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprotobuf_ABSL_PROVIDER=package
-Dprotobuf_BUILD_TESTS=OFF
-DBUILD_SHARED_LIBS=OFF
-DCMAKE_INSTALL_LIBDIR=lib
"

termux_step_post_get_source() {
	# Version guard
	local ver_e=${TERMUX_PKG_VERSION#*:}
	local ver_x=$(. $TERMUX_SCRIPTDIR/packages/libprotobuf/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	if [ "${ver_e}" != "${ver_x}" ]; then
		termux_error_exit "Version mismatch between libprotobuf and protobuf-static."
	fi
}

termux_step_pre_configure() {
	# Version guard
	local ver_shared=$(. $TERMUX_SCRIPTDIR/packages/libprotobuf/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	local ver_static=${TERMUX_PKG_VERSION#*:}
	if [ "${ver_shared}" != "${ver_static}" ]; then
		termux_error_exit "Version mismatch between libprotobuf and protobuf-static."
	fi
}

termux_step_post_make_install() {
	# Copy lib/*.cmake to opt/protobuf-cmake/static for future use
	mkdir -p $TERMUX_PREFIX/opt/protobuf-cmake/static
	cp $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-targets{,-release}.cmake \
		$TERMUX_PREFIX/opt/protobuf-cmake/static/
}

termux_step_post_massage() {
	find . ! -type d \
		! -wholename "./lib/*.a" \
		! -wholename "./lib/cmake/protobuf/protobuf-targets-release.cmake" \
		! -wholename "./lib/cmake/protobuf/protobuf-targets.cmake" \
		! -wholename "./opt/protobuf-cmake/static/protobuf-targets-release.cmake" \
		! -wholename "./opt/protobuf-cmake/static/protobuf-targets.cmake" \
		! -wholename "./share/doc/$TERMUX_PKG_NAME/*" \
		-exec rm -f '{}' \;
	find . ! -type d \
		-wholename "./lib/libutf8_*" \
		-exec rm -f '{}' \;
	find . -type d -empty -delete
}
