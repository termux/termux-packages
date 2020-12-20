TERMUX_PKG_HOMEPAGE=https://man7.org/linux/man-pages/man5/resolv.conf.5.html
TERMUX_PKG_DESCRIPTION="Resolver configuration file"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SKIP_SRC_EXTRACT=true

TERMUX_PKG_CONFFILES="
etc/hosts
etc/resolv.conf
"

termux_step_make_install() {
	printf "127.0.0.1 localhost\n::1 ip6-localhost\n" > $TERMUX_PREFIX/etc/hosts
	printf "nameserver 8.8.8.8\nnameserver 8.8.4.4\n" > $TERMUX_PREFIX/etc/resolv.conf
}
