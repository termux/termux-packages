TERMUX_PKG_HOMEPAGE=https://acoustid.org/chromaprint
TERMUX_PKG_DESCRIPTION="C library for generating audio fingerprints used by AcoustID"
TERMUX_PKG_LICENSE="LGPL-2.1, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_SRCURL=https://github.com/acoustid/chromaprint/releases/download/v${TERMUX_PKG_VERSION}/chromaprint-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a1aad8fa3b8b18b78d3755b3767faff9abb67242e01b478ec9a64e190f335e1c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=ffmpeg
# `-DBUILD_TOOLS=ON` is not speficied as `fpcalc` does not build with ffmpeg 5.0.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DBUILD_SHARED_LIBS=ON
-DBUILD_TOOLS=OFF
-DBUILD_TESTS=OFF
"

termux_step_post_make_install() {
	ln -sf libchromaprint.so \
		"${TERMUX_PREFIX}/lib/libchromaprint.so.${TERMUX_PKG_VERSION:0:1}"
	ln -sf libchromaprint.so \
		"${TERMUX_PREFIX}/lib/libchromaprint.so.${TERMUX_PKG_VERSION}"
}
