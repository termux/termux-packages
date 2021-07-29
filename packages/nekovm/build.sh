TERMUX_PKG_HOMEPAGE="https://nekovm.org/"
TERMUX_PKG_DESCRIPTION="The Neko Virtual Machine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/HaxeFoundation/neko/archive/refs/tags/v${TERMUX_PKG_VERSION//[.]/-}.tar.gz
TERMUX_PKG_SHA256=850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995
TERMUX_PKG_DEPENDS="libgc,openssl,zlib,apache2,libsqlite,mbedtls"

termux_step_configure() {
        termux_setup_cmake
        cmake -S ../src \
                -Wno-dev \
                -G "Unix Makefiles" \
                -DCMAKE_INSTALL_PREFIX:PATH=$TERMUX_PREFIX \
                -DWITH_UI=n \
                -DWITH_MYSQL=n \
                -DWITH_REGEXP=n
}
