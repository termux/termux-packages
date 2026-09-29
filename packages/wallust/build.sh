TERMUX_PKG_HOMEPAGE=https://explosion-mental.codeberg.page/wallust
TERMUX_PKG_DESCRIPTION="Generate colors from an image"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.2"
TERMUX_PKG_SRCURL="https://codeberg.org/explosion-mental/wallust/archive/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=46c2592217f0de968437850b14b2e844f2af4158b70135b2b448dc426c0309a1
TERMUX_PKG_RECOMMENDS="imagemagick"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
	export TERMUX_PKG_EXTRA_MAKE_ARGS="
		CARGO=$(command -v cargo)
	"

	# prevents "gcc: error: unrecognized command-line option '-mfpu=neon'" when targeting 32-bit
	unset CFLAGS
}
