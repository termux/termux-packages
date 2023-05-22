TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@esque.ca>"
_COMMIT=5b53bf803dae14cbb77610b1a1bb2ce9eb2ea22a
TERMUX_PKG_VERSION="2023.05.22-${_COMMIT:0:8}"
TERMUX_PKG_SHA256="b8ecd0eb569a7ab9626e954be99e09c43b7ec9e02b34ad28db33177ffba817ec"
TERMUX_PKG_SRCURL="https://github.com/RfidResearchGroup/proxmark3/archive/${_COMMIT}.tar.gz"
TERMUX_PKG_DEPENDS="libbz2, libc++, readline"
TERMUX_PKG_BUILD_IN_SRC="true"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"
TERMUX_PKG_CONFLICTS="proxmark3"

termux_step_post_configure() {
	LDLIBS="-L${TERMUX_PREFIX}/lib" INCLUDES_CLIENT="-I${TERMUX_PREFIX}/include" CFLAGS="-I${TERMUX_PREFIX}/include"
	TERMUX_PKG_EXTRA_MAKE_ARGS="client -j $TERMUX_MAKE_PROCESSES CC=$CC CXX=$CXX LD=$CXX cpu_arch=$TERMUX_ARCH SKIPREVENGTEST=1 SKIPQT=1 SKIPBT=1 SKIPPTHREAD=1 SKIPGPU=1 PLATFORM=PM3GENERIC"
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/client/proxmark3 \
		"$TERMUX_PREFIX"/bin/proxmark3
}
