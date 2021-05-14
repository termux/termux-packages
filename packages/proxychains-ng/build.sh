TERMUX_PKG_HOMEPAGE=https://github.com/rofl0r/proxychains-ng
TERMUX_PKG_DESCRIPTION="A hook preloader that allows to redirect TCP traffic of existing dynamically linked programs through one or more SOCKS or HTTP proxies"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.16
TERMUX_PKG_SRCURL=https://github.com/rofl0r/proxychains-ng/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5f66908044cc0c504f4a7e618ae390c9a78d108d3f713d7839e440693f43b5e7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	make install-config DESTDIR=$TERMUX_PKG_MASSAGEDIR
}
