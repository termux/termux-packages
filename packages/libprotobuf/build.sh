TERMUX_PKG_HOMEPAGE=https://github.com/protocolbuffers/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
# TERMUX_PKG_SRCDIR is overriden below so we need to specify license file
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2:3.19.2
TERMUX_PKG_SRCURL=https://github.com/protocolbuffers/protobuf/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=4dd35e788944b7686aac898f77df4e9a54da0ca694b8801bd6b2a9ffc1b3085e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="libprotobuf-dev"
TERMUX_PKG_REPLACES="libprotobuf-dev"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprotobuf_BUILD_TESTS=OFF
-DBUILD_SHARED_LIBS=ON
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/cmake/"
}
