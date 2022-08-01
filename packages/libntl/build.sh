TERMUX_PKG_HOMEPAGE="https://libntl.org"
TERMUX_PKG_DESCRIPTION="A Library for doing Number Theory"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="doc/copying.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="11.5.1"
TERMUX_PKG_SRCURL="https://libntl.org/ntl-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=210d06c31306cbc6eaf6814453c56c776d9d8e8df36d74eb306f6a523d1c6a8a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="perl"
TERMUX_PKG_DEPENDS="libgmp"
# TERMUX_PKG_DEPENDS="gf2x, libgmp"

termux_step_configure() {
    cd src
    ./configure \
        PREFIX=$TERMUX_PREFIX\
        NATIVE=off \
        TUNE=generic \
        NTL_GMP_LIP=on \
        NTL_GF2X_LIB=off
}

termux_step_make() {
    cd src
    make
}

termux_step_make_install() {
    cd src
    make install
}

