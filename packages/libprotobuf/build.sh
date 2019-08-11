TERMUX_PKG_HOMEPAGE=https://github.com/google/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=3.9.1
TERMUX_PKG_SRCURL=https://github.com/google/protobuf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=98e615d592d237f94db8bf033fba78cd404d979b0b70351a9e5aaff725398357
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="libprotobuf-dev"
TERMUX_PKG_REPLACES="libprotobuf-dev"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprotobuf_BUILD_TESTS=OFF
-DBUILD_SHARED_LIBS=ON
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/cmake/"
}
