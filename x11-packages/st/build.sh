TERMUX_PKG_HOMEPAGE=https://st.suckless.org/
TERMUX_PKG_DESCRIPTION="A simple virtual terminal emulator for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=0.8.4
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="http://dl.suckless.org/st/st-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d42d3ceceb4d6a65e32e90a5336e3d446db612c3fbd9ebc1780bc6c9a03346a6
# FIXME: config.h specified a Liberation Mono font which is not available in Termux.
# Needs a patch for ttf-dejavu font package or liberation font package should be added.
TERMUX_PKG_DEPENDS="libxft, libxext"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="TERMINFO=$TERMUX_PREFIX/share/terminfo"
TERMUX_PKG_RM_AFTER_INSTALL="share/terminfo"

termux_step_configure() {
	cp "$TERMUX_PKG_BUILDER_DIR/config.h" "config.h"
}
