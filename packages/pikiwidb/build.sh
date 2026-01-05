TERMUX_PKG_HOMEPAGE=https://github.com/OpenAtomFoundation/pikiwidb
TERMUX_PKG_DESCRIPTION="Redis-Compatible database developed by Qihoo's infrastructure team"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(3.5.6
					1.0.7)
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=("https://github.com/OpenAtomFoundation/pikiwidb/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
					"https://github.com/pikiwidb/rediscache/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz")
TERMUX_PKG_SHA256=(b8081375426d1769ecc4a5fe70c5109589ef374f5d9030ea0adc4ea5a1dab9fa
					6d09b5699030e74914da085a10fd6010336572b30894d93e4f024fa67d36f2a8)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, fmt, gflags, google-glog, libc++, libprotobuf, librocksdb, zlib"
# required during build, but binary does not become linked to them
TERMUX_PKG_BUILD_DEPENDS="googletest, liblz4, libsnappy, zstd"
TERMUX_PKG_CONFLICTS="pika"
TERMUX_PKG_BREAKS="pika"
TERMUX_PKG_REPLACES="pika"
# src/pika_monotonic_time.cc:47:2: error: "Unsupported architecture for Linux"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_pre_configure() {
	# build and install rediscache component
	(
	export TERMUX_PKG_SRCDIR+="/rediscache-${TERMUX_PKG_VERSION[1]}"
	export TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR/build"
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure
	termux_step_make
	ninja install
	)
	cd "$TERMUX_PKG_BUILDDIR"

	termux_setup_protobuf
	export PROTOC_PATH="$(dirname $(command -v protoc))"

	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
	# from PREFIX/lib/cmake/glog/glog-targets.cmake
	CPPFLAGS+=" -DGLOG_USE_GLOG_EXPORT -DGLOG_USE_GFLAGS"
	CPPFLAGS+=" -DHAS_PTHREAD_SETNAME_NP"
	CPPFLAGS+=" -I$TERMUX_PREFIX/include/rocksdb"

	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}

termux_step_make_install () {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "$TERMUX_PKG_BUILDDIR/pika"
	install -Dm600 -t "$TERMUX_PREFIX/share/pika" "$TERMUX_PKG_SRCDIR/conf/pika.conf"
}
