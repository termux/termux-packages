TERMUX_PKG_HOMEPAGE="https://sourceforge.net/projects/tinyxml"
TERMUX_PKG_DESCRIPTION="A simple, small, C++ XML parser"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="readme.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.2"
TERMUX_PKG_SRCURL="http://downloads.sourceforge.net/tinyxml/tinyxml_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=15bdfdcec58a7da30adc87ac2b078e4417dbe5392f3afb719f9ba6d062645593
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64, arm, i686"

termux_step_pre_configure() {
    sed -i Makefile \
        -e '/^TINYXML_USE_STL/ s|=.*|=YES|' \
        -e "s|^RELEASE_CFLAGS.*|& ${CXXFLAGS/-Oz/-Os} -fPIC|"
}

termux_step_make() {
    make -j $TERMUX_MAKE_PROCESSES
    g++ -fPIC $CXXFLAGS -shared -o libtinyxml.so.0.$TERMUX_PKG_VERSION \
        -Wl,-soname,libtinyxml.so.0 $(ls *.o | grep -v xmltest)
}

termux_step_make_install() {
    install -m 0755 "libtinyxml.so.0.$TERMUX_PKG_VERSION" \
        "$TERMUX_PREFIX/lib/"
    install -m 0644 tinyxml.h tinystr.h \
        "$TERMUX_PREFIX/include/"
    cd "$TERMUX_PREFIX/lib"
    ln -s "libtinyxml.so.0.$TERMUX_PKG_VERSION" libtinyxml.so
    ln -s "libtinyxml.so.0.$TERMUX_PKG_VERSION" libtinyxml.so.0
}
