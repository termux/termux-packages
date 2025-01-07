TERMUX_PKG_HOMEPAGE=https://github.com/protocolbuffers/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
# utf8_range is licensed under MIT
TERMUX_PKG_LICENSE="BSD 3-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
# When bumping version:
# - update SHA256 checksum for $_PROTOBUF_ZIP in
#     $TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_protobuf.sh
# - ALWAYS bump revision of reverse dependencies and rebuild them.
TERMUX_PKG_VERSION=2:25.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/protocolbuffers/protobuf/archive/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=9bd87b8280ef720d3240514f884e56a712f2218f0d693b48050c836028940a42
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="abseil-cpp, libc++, zlib"
TERMUX_PKG_BREAKS="libprotobuf-dev, protobuf-static (<< ${TERMUX_PKG_VERSION#*:})"
TERMUX_PKG_REPLACES="libprotobuf-dev"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprotobuf_ABSL_PROVIDER=package
-Dprotobuf_BUILD_TESTS=OFF
-DBUILD_SHARED_LIBS=ON
-DCMAKE_INSTALL_LIBDIR=lib
"
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/libutf8-range \
		$TERMUX_PKG_SRCDIR/third_party/utf8_range/LICENSE

	# Copy lib/*.cmake to opt/protobuf-cmake/shared for future use
	mkdir -p $TERMUX_PREFIX/opt/protobuf-cmake/shared
	cp $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-targets{,-release}.cmake \
		$TERMUX_PREFIX/opt/protobuf-cmake/shared/
}
