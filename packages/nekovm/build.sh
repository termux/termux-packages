TERMUX_PKG_HOMEPAGE="https://nekovm.org/"
TERMUX_PKG_DESCRIPTION="The Neko Virtual Machine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/HaxeFoundation/neko/archive/refs/tags/v${TERMUX_PKG_VERSION//[.]/-}.tar.gz
TERMUX_PKG_SHA256=850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995
TERMUX_PKG_DEPENDS="libgc,openssl,zlib,apache2,libsqlite,mbedtls"
TERMUX_CMAKE_BUILD="Unix Makefiles"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Wno-dev
-DWITH_UI=n
-DWITH_MYSQL=n
-DWITH_REGEXP=n
"
