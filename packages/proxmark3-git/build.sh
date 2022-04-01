TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
_COMMIT=247790b8334fdbbf3e7efb7a6192850750c32931
TERMUX_PKG_REVISION=1
TERMUX_PKG_VERSION="2022.03.31-${_COMMIT:0:8}"
TERMUX_PKG_SRCURL="https://github.com/RfidResearchGroup/proxmark3/archive/${_COMMIT}.tar.gz"
TERMUX_PKG_SHA256="d3beb40c67f8537b3d0a65c8cf9205300ce53741022d0ed2d56c43dde4107323"
TERMUX_PKG_DEPENDS="libbz2, libc++, readline"
TERMUX_PKG_BUILD_IN_SRC="true"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"

termux_step_post_configure() {
        LDLIBS="-L${TERMUX_PREFIX}/lib" INCLUDES_CLIENT="-I${TERMUX_PREFIX}/include" CFLAGS="-I${TERMUX_PREFIX}/include"
        make clean
        TERMUX_PKG_EXTRA_MAKE_ARGS="client -j $TERMUX_MAKE_PROCESSES CC=$CC CXX=$CXX LD=$CXX SKIPREVENGTEST=1 SKIPQT=1 SKIPBT=1 SKIPPTHREAD=1 SKIPGPU=1 cpu_arch=$TERMUX_ARCH"
}

termux_step_make_install() {
        install -Dm700 "$TERMUX_PKG_BUILDDIR"/client/proxmark3 \
                "$TERMUX_PREFIX"/bin/proxmark3
}
