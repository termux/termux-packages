TERMUX_PKG_HOMEPAGE=https://www.lenguajelatino.org/
TERMUX_PKG_DESCRIPTION="Lenguaje de programación de código abierto para latinos y de habla hispana."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/primitivorm/latino-termux/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e860962fbd4933b510ccc5b1d8d7efeb71cd5a7b7bb60f27971270866ad2de69
TERMUX_PKG_DEPENDS="make, clang, readline, pcre2"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$PREFIX"
