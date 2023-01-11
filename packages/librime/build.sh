TERMUX_PKG_HOMEPAGE=https://rime.im/
TERMUX_PKG_DESCRIPTION="A modular, extensible input method engine in cross-platform C++ code"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.3
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/rime/librime/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c76b937a27d7b9352c3eea9eb3adaebf70c93457104c7d47d40c006009092c20
TERMUX_PKG_DEPENDS="boost, capnproto, google-glog, leveldb, libc++, libopencc, libyaml-cpp, marisa"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, gflags, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TEST=OFF
"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	# We build capnproto here to avoid API mismatch
	local CAPNPROTO_BUILD_SH=$TERMUX_SCRIPTDIR/packages/capnproto/build.sh
	local CAPNPROTO_SRCURL=$(bash -c ". $CAPNPROTO_BUILD_SH; echo \$TERMUX_PKG_SRCURL")
	local CAPNPROTO_SHA256=$(bash -c ". $CAPNPROTO_BUILD_SH; echo \$TERMUX_PKG_SHA256")
	local CAPNPROTO_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $CAPNPROTO_SRCURL)
	termux_download $CAPNPROTO_SRCURL $CAPNPROTO_TARFILE $CAPNPROTO_SHA256
	local CAPNPROTO_SRCDIR=$TERMUX_PKG_SRCDIR/capnproto
	mkdir -p $CAPNPROTO_SRCDIR
	tar xf $CAPNPROTO_TARFILE -C $CAPNPROTO_SRCDIR --strip-components=1

	termux_setup_cmake

	mkdir -p capnproto
	pushd capnproto
	cmake $CAPNPROTO_SRCDIR
	make -j $TERMUX_MAKE_PROCESSES
	popd
}

termux_step_pre_configure() {
	local CAPNPROTO_BIN=$TERMUX_PKG_HOSTBUILD_DIR/capnproto/src/capnp
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DCAPNP_EXECUTABLE=$CAPNPROTO_BIN/capnp
		-DCAPNPC_CXX_EXECUTABLE=$CAPNPROTO_BIN/capnpc-c++
		"
}

