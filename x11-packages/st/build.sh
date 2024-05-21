TERMUX_PKG_HOMEPAGE=https://st.suckless.org/
TERMUX_PKG_DESCRIPTION="A simple virtual terminal emulator for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_SRCURL="https://dl.suckless.org/st/st-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=6b215d4f472b21d6232f30f221117a777e24bcfee68955ddefb7426467f9494b
TERMUX_PKG_AUTO_UPDATE=true
# FIXME: config.h specified a Liberation Mono font which is not available in Termux.
# Needs a patch for ttf-dejavu font package or liberation font package should be added.
TERMUX_PKG_DEPENDS="fontconfig, freetype, libx11, libxft"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="TERMINFO=$TERMUX_PREFIX/share/terminfo"
TERMUX_PKG_RM_AFTER_INSTALL="share/terminfo"

termux_step_pre_configure() {
	cp config.def.h config.h
}
