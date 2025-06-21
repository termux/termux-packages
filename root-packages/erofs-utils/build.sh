TERMUX_PKG_HOMEPAGE=https://github.com/erofs/erofs-utils
TERMUX_PKG_DESCRIPTION="A github erofs-utils fork for community development"
TERMUX_PKG_LICENSE="GPL-2.0, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSES/GPL-2.0, LICENSES/Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.7"
TERMUX_PKG_SRCURL=https://github.com/erofs/erofs-utils/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d84941a83369a9128f2d57b3014aac86e63ca1ab03000a9f5bb21c703f10d272
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="liblz4, liblzma, libfuse2, libuuid, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--prefix=$TERMUX_PREFIX --enable-lzma --enable-fuse"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
