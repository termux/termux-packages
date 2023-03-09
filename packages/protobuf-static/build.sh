TERMUX_PKG_HOMEPAGE=https://github.com/protocolbuffers/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library (static)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# Please align the version with `libprotobuf` package.
TERMUX_PKG_VERSION=22.1
TERMUX_PKG_SRCURL=https://github.com/protocolbuffers/protobuf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b6494b6e1a8d197f6626ca0c5aa9ab35fc1e5aa3f724787133ce4fa4aa78499
TERMUX_PKG_DEPENDS="protobuf (>= 2:${TERMUX_PKG_VERSION})"
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

termux_step_pre_configure() {
	# Version guard
	local ver_shared=$(. $TERMUX_SCRIPTDIR/packages/libprotobuf/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	local ver_static=${TERMUX_PKG_VERSION#*:}
	if [ "${ver_shared}" != "${ver_static}" ]; then
		termux_error_exit "Version mismatch between libprotobuf and protobuf-static."
	fi

	# Preserve CMake files for shared libs
	local f
	for f in $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-targets{-release,}.cmake; do
		if [ -e "${f}" ]; then
			mv "${f}"{,.tmp}
		fi
	done
}

termux_step_post_massage() {
	find . ! -type d \
		! -wholename "./lib/*.a" \
		! -wholename "./lib/cmake/protobuf/protobuf-targets-release.cmake" \
		! -wholename "./lib/cmake/protobuf/protobuf-targets.cmake" \
		! -wholename "./share/doc/$TERMUX_PKG_NAME/*" \
		-exec rm -f '{}' \;
	find . ! -type d \
		-wholename "./lib/libutf8_*" \
		-exec rm -f '{}' \;
	find . -type d -empty -delete

	# Restore CMake files for shared libs
	local f
	for f in $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-targets{-release,}.cmake; do
		if [ -e "${f}".tmp ]; then
			mv "${f}"{.tmp,}
		fi
	done
}
