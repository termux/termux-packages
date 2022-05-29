TERMUX_PKG_HOMEPAGE=https://alist-doc.nn.ci
TERMUX_PKG_DESCRIPTION="A file list program that supports multiple storage"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/pngwriter/pngwriter/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=82d46eef109f434f95eba9cf5908710ae4e75f575fd3858178ad06e800152825
TERMUX_PKG_DEPENDS="zlib,freetype,libpng"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
        termux_setup_cmake
        cmake ${TERMUX_PKG_SRCDIR}
        make -j $TERMUX_MAKE_PROCESSES
}
