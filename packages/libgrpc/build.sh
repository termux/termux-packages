TERMUX_PKG_HOMEPAGE=https://grpc.io/
TERMUX_PKG_DESCRIPTION="High performance, open source, general RPC framework that puts mobile and HTTP/2 first"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=git+https://github.com/grpc/grpc
TERMUX_PKG_VERSION=1.52.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="abseil-cpp, c-ares, ca-certificates, libc++, libprotobuf, libre2, openssl, protobuf, zlib"
TERMUX_PKG_BREAKS="libgrpc-dev"
TERMUX_PKG_REPLACES="libgrpc-dev"
TERMUX_PKG_BUILD_DEPENDS="gflags, gflags-static"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_STRIP=$(command -v strip)
-DGIT_EXECUTABLE=$(command -v git)
-DBUILD_SHARED_LIBS=ON
-DgRPC_ABSL_PROVIDER=package
-DgRPC_CARES_PROVIDER=package
-DgRPC_PROTOBUF_PROVIDER=package
-DgRPC_SSL_PROVIDER=package
-DgRPC_RE2_PROVIDER=package
-DgRPC_ZLIB_PROVIDER=package
-DgRPC_GFLAGS_PROVIDER=package
-DRUN_HAVE_POSIX_REGEX=0
-DRUN_HAVE_STD_REGEX=0
-DRUN_HAVE_STEADY_CLOCK=0
-DProtobuf_PROTOC_LIBRARY=$TERMUX_PREFIX/lib/libprotoc.so
"

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	export LD=gcc
	export LDXX=g++

	# -Wno-error=class-memaccess is used to avoid
	# src/core/lib/security/credentials/oauth2/oauth2_credentials.cc:336:61: error: ‘void* memset(void*, int, size_t)’ clearing an object of non-trivial type ‘struct grpc_oauth2_token_fetcher_credentials’; use assignment or value-initialization instead [-Werror=class-memaccess]
	# memset(c, 0, sizeof(grpc_oauth2_token_fetcher_credentials));
	# when building version 1.17.2:
	CXXFLAGS="-Wno-error=class-memaccess" \
		CFLAGS="-Wno-implicit-fallthrough" \
		cmake -G Ninja "$TERMUX_PKG_SRCDIR"

	ninja grpc_cpp_plugin
}

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_cmake
	termux_setup_ninja

	export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
	export GRPC_CROSS_COMPILE=true

	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}
