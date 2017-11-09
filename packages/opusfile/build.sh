TERMUX_PKG_HOMEPAGE=https://www.opus-codec.org/
TERMUX_PKG_DESCRIPTION="A high-level API for decoding and seeking within .opus files"
TERMUX_PKG_VERSION=0.9
TERMUX_PKG_SHA256=63b52a975c5ec90026e00de99712fc1244abc40d396a20a22060671465e2ed4e
TERMUX_PKG_SRCURL=https://github.com/xiph/opusfile/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libopus, libogg"

termux_step_pre_configure() {
  ./autogen.sh
}
