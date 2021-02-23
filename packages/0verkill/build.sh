TERMUX_PKG_HOMEPAGE=https://github.com/hackndev/0verkill
TERMUX_PKG_DESCRIPTION="Bloody 2D action deathmatch-like game in ASCII-ART"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.16-git
_COMMIT=522f11a3e40670bbf85e0fada285141448167968
TERMUX_PKG_SRCURL=https://github.com/hackndev/0verkill/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=91360d5e248ef3b883c6fc994a1564ef5f863b663d1a6f0f751122384b845bb8
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vfi
}
