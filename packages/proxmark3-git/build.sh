TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
TERMUX_PKG_REVISION=1
TERMUX_PKG_VERSION="2021.05.10-0d3c2978"
TERMUX_PKG_SRCURL=https://github.com/RfidResearchGroup/proxmark3/archive/0d3c2978a6516def4d722cacdb9d651b087df2a1.tar.gz
TERMUX_PKG_SHA256=702e50af914dbc23ad2bb41de19217dc5408f7ae7181868e005dc1052051355d
TERMUX_PKG_BUILD_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC="true"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"

termux_step_make() {
        LDLIBS="-L${TERMUX_PREFIX}/lib" INCLUDES_CLIENT="-I${TERMUX_PREFIX}/include/" \
        make client -j $TERMUX_MAKE_PROCESSES CC=$CC CXX=$CXX LD=$CXX cpu_arch=generic SKIPREVENGTEST=1 SKIPQT=1 SKIPBT=1 SKIPPTHREAD=1 SKIPGPU=1 PLATFORM=PM3GENERIC
}

termux_step_make_install() {
        install -Dm700 "$TERMUX_PKG_BUILDDIR"/client/proxmark3 \
                "$TERMUX_PREFIX"/bin/proxmark3
}
