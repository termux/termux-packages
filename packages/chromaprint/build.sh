TERMUX_PKG_HOMEPAGE=https://acoustid.org/chromaprint
TERMUX_PKG_DESCRIPTION="C library for generating audio fingerprints used by AcoustID"
TERMUX_PKG_LICENSE="LGPL-2.1, MIT"
TERMUX_PKG_VERSION=1.4.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/acoustid/chromaprint/releases/download/v${TERMUX_PKG_VERSION}/chromaprint-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea18608b76fb88e0203b7d3e1833fb125ce9bb61efe22c6e169a50c52c457f82
TERMUX_PKG_DEPENDS=ffmpeg
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Release -DBUILD_TOOLS=ON -DBUILD_SHARED_LIBS=ON"
termux_step_post_make_install() {
  ln -sf "${TERMUX_PREFIX}/lib/libchromaprint.so" "${TERMUX_PREFIX}/lib/libchromaprint.so.${TERMUX_PKG_VERSION:0:1}"
  ln -sf "${TERMUX_PREFIX}/lib/libchromaprint.so" "${TERMUX_PREFIX}/lib/libchromaprint.so.${TERMUX_PKG_VERSION}"
}
