TERMUX_PKG_HOMEPAGE="https://sourceforge.net/projects/tinyxml"
TERMUX_PKG_DESCRIPTION="A simple, small, C++ XML parser"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="readme.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="http://downloads.sourceforge.net/tinyxml/tinyxml_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=15bdfdcec58a7da30adc87ac2b078e4417dbe5392f3afb719f9ba6d062645593
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_make_install() {
    install -m 0755 libtinyxml.so \
        "$TERMUX_PREFIX/lib/"
    install -m 0644 tinyxml.h tinystr.h \
        "$TERMUX_PREFIX/include/"
}
