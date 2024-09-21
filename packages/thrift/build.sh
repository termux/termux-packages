TERMUX_PKG_HOMEPAGE=https://thrift.apache.org
TERMUX_PKG_DESCRIPTION="Scalable cross-language services framework for IPC/RPC"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.0"
TERMUX_PKG_SRCURL=https://downloads.apache.org/thrift/${TERMUX_PKG_VERSION}/thrift-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9a24f3eba9a4ca493602226c16d8c228037db3b9291c6fc4019bfe3bd39fc67c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++, openssl"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
# cmake options are copied from https://github.com/apache/arrow/blob/main/cpp/cmake_modules/ThirdpartyToolchain.cmake
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_COMPILER=OFF
-DBUILD_EXAMPLES=OFF
-DBUILD_SHARED_LIBS=ON
-DBUILD_TUTORIALS=OFF
-DWITH_AS3=OFF
-DWITH_CPP=ON
-DWITH_C_GLIB=OFF
-DWITH_JAVA=OFF
-DWITH_JAVASCRIPT=OFF
-DWITH_LIBEVENT=OFF
-DWITH_NODEJS=OFF
-DWITH_PYTHON=OFF
-DWITH_QT5=OFF
-DWITH_ZLIB=OFF
"

termux_step_pre_configure() {
	rm configure
}
