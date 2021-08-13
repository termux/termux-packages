TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
_COMMIT="a6cb675a5b47de42cec5f8aafc9eefd60439f052"
TERMUX_PKG_VERSION="2021.08.12-${_COMMIT:0:8}"
TERMUX_PKG_SRCURL="https://github.com/RfidResearchGroup/proxmark3/archive/a6cb675a5b47de42cec5f8aafc9eefd60439f052.tar.gz"
TERMUX_PKG_SHA256="2ff93e4d673666793f6a9fa098ab4bcac151c62ed11d909354446dc862a94398"
TERMUX_PKG_DEPENDS="libbz2, libc++, readline"
TERMUX_PKG_BUILD_IN_SRC="true"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"

termux_step_post_configure() {
        LDLIBS="-L${TERMUX_PREFIX}/lib" INCLUDES_CLIENT="-I${TERMUX_PREFIX}/include" CFLAGS="-I${TERMUX_PREFIX}/include"
        TERMUX_PKG_EXTRA_MAKE_ARGS="client -j $TERMUX_MAKE_PROCESSES CC=$CC CXX=$CXX LD=$CXX cpu_arch=generic SKIPREVENGTEST=1 SKIPQT=1 SKIPBT=1 SKIPPTHREAD=1 SKIPGPU=1 PLATFORM=PM3GENERIC"
}

termux_step_make_install() {
        install -Dm700 "$TERMUX_PKG_BUILDDIR"/client/proxmark3 \
                "$TERMUX_PREFIX"/bin/proxmark3
}
