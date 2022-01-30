TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
_COMMIT=a79b23edc408c95f689c917982f3bd0811d52a98
TERMUX_PKG_VERSION="2022.01.29-${_COMMIT:0:8}"
TERMUX_PKG_SRCURL="https://github.com/RfidResearchGroup/proxmark3/archive/${_COMMIT}.tar.gz"
TERMUX_PKG_SHA256="a94ffbdc16944db403ad648adde5d72b016769c979033b4b0a5cb4e94b50b931"
TERMUX_PKG_DEPENDS="libbz2, libc++, readline, binutils"
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
