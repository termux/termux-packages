TERMUX_PKG_HOMEPAGE=https://github.com/Xfennec/progress
TERMUX_PKG_DESCRIPTION="Linux tool to show progress for cp, mv, dd and more"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Xfennec/progress/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ee9538fce98895dcf0d108087d3ee2e13f5c08ed94c983f0218a7a3d153b725d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libandroid-wordexp, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-wordexp"
}
