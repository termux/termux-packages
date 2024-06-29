TERMUX_PKG_HOMEPAGE=https://grpc.io/
TERMUX_PKG_DESCRIPTION="High performance, open source, general RPC framework that puts mobile and HTTP/2 first"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=git+https://github.com/grpc/grpc
TERMUX_PKG_VERSION="1.65.0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_DEPENDS="abseil-cpp, c-ares, ca-certificates, libc++, libre2, openssl, python, zlib"
TERMUX_PKG_BUILD_DEPENDS="gflags, gflags-static"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools, 'Cython>=3.0.0'"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm CMakeLists.txt Makefile Rakefile

	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	export GRPC_PYTHON_BUILD_SYSTEM_RE2=1
	export GRPC_PYTHON_BUILD_SYSTEM_ABSL=1
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
}
