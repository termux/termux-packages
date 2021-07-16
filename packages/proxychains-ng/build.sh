TERMUX_PKG_HOMEPAGE=https://github.com/rofl0r/proxychains-ng
TERMUX_PKG_DESCRIPTION="A hook preloader that allows to redirect TCP traffic of existing dynamically linked programs through one or more SOCKS or HTTP proxies"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.14
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/rofl0r/proxychains-ng/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ab31626af7177cc2669433bb244b99a8f98c08031498233bb3df3bcc9711a9cc
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	make install-config DESTDIR=$TERMUX_PKG_MASSAGEDIR
}
