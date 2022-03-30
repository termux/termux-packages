TERMUX_PKG_HOMEPAGE=https://github.com/hackerb9/lsix
TERMUX_PKG_DESCRIPTION="Shows thumbnails in terminal using sixel graphics"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_SRCURL=https://github.com/hackerb9/lsix/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f19b0456abb72e203fa20edeb568883d4fe9c0e9555c6752644f313a6811f98e
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin lsix
}
