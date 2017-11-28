TERMUX_PKG_HOMEPAGE=https://grpc.io/
TERMUX_PKG_DESCRIPTION="High performance, open source, general RPC framework that puts mobile and HTTP/2 first"
TERMUX_PKG_VERSION=1.4.7
TERMUX_PKG_SHA256=9ce1ae3a05932eee41d7de28a59cff9d493b3423c571f51000bb350313e61b72
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_SRCURL=https://github.com/grpc/grpc/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="openssl, protobuf, c-ares"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DgRPC_CARES_PROVIDER=package
-DgRPC_PROTOBUF_PROVIDER=package
-DgRPC_SSL_PROVIDER=package
-DgRPC_ZLIB_PROVIDER=package
-D_gRPC_PROTOBUF_PROTOC=$TERMUX_TOPDIR/libprotobuf/host-build/src/protoc
"

termux_step_host_build () {
	termux_setup_cmake
	local protoinstall=$TERMUX_TOPDIR/libprotobuf/host-build/install
	cmake $TERMUX_PKG_SRCDIR -G "Unix Makefiles" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS \
		-DCMAKE_CXX_FLAGS="-I$protoinstall/include -L$protoinstall/lib" \
		-D_gRPC_PROTOBUF_LIBRARIES="-lprotobuf -lprotoc"
	make -j $TERMUX_MAKE_PROCESSES grpc_cpp_plugin
}

termux_step_pre_configure () {
	sed "s|@PATH_TO_PLUGIN@|$TERMUX_PKG_HOSTBUILD_DIR/grpc_cpp_plugin|g" $TERMUX_PKG_BUILDER_DIR/CMakeLists.txt.diff | patch -p1

	export GRPC_CROSS_COMPILE=true
	LDFLAGS="$LDFLAGS -lprotobuf -lprotoc -lcares -llog -lz"
}
