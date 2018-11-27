TERMUX_PKG_HOMEPAGE=https://grpc.io/
TERMUX_PKG_DESCRIPTION="High performance, open source, general RPC framework that puts mobile and HTTP/2 first"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=1.16.1
TERMUX_PKG_DEPENDS="openssl, protobuf, c-ares"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_STRIP=`which strip`
-DGIT_EXECUTABLE=`which git`
-DBUILD_SHARED_LIBS=ON
-DgRPC_CARES_PROVIDER=package
-DgRPC_PROTOBUF_PROVIDER=package
-DgRPC_SSL_PROVIDER=package
-DgRPC_ZLIB_PROVIDER=package
-DProtobuf_PROTOC_EXECUTABLE=$TERMUX_TOPDIR/libprotobuf/host-build/src/protoc
-DRUN_HAVE_POSIX_REGEX=0
-DRUN_HAVE_STD_REGEX=0
-DRUN_HAVE_STEADY_CLOCK=0
"

termux_step_extract_package() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/checkout-$TERMUX_PKG_VERSION
	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
		rm -Rf $TMP_CHECKOUT
		mkdir -p $TMP_CHECKOUT

		git clone --depth 1 \
			--branch v$TERMUX_PKG_VERSION \
			https://github.com/grpc/grpc.git \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT
		git submodule update --init # --depth 1
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	mkdir $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER/* .
}

termux_step_host_build () {
	termux_setup_cmake
	local protoinstall=$TERMUX_TOPDIR/libprotobuf/host-build/install
	cd $TERMUX_PKG_SRCDIR
	export LD=gcc
	export LDXX=g++
	CFLAGS="-Wno-implicit-fallthrough" \
		make -j $TERMUX_MAKE_PROCESSES \
		HAS_SYSTEM_PROTOBUF=false \
		prefix=$TERMUX_PKG_HOSTBUILD_DIR \
		install
	make clean
}

termux_step_pre_configure() {
	sed "s|@PATH_TO_PLUGIN@|$TERMUX_PKG_HOSTBUILD_DIR/bin/grpc_cpp_plugin|g" \
		$TERMUX_PKG_BUILDER_DIR/CMakeLists.txt.diff \
		| patch -p1
	export GRPC_CROSS_COMPILE=true
}
