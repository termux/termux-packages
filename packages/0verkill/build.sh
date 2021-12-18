TERMUX_PKG_HOMEPAGE=https://github.com/hackndev/0verkill
TERMUX_PKG_DESCRIPTION="Bloody 2D action deathmatch-like game in ASCII-ART"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.16-git
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/ravener/0verkill/archive/refs/tags/v${TERMUX_PKG_VERSION:0:4}.tar.gz
TERMUX_PKG_SHA256=d337e4a7dd91f26c837e96492d960c7fd77c75bc24bcc6ed8d350df39edf8bb8
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	autoreconf -vfi
	CFLAGS+=" -fcommon"
}
