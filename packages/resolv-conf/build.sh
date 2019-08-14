TERMUX_PKG_HOMEPAGE=http://man7.org/linux/man-pages/man5/resolv.conf.5.html
TERMUX_PKG_DESCRIPTION="Resolver configuration file"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_CONFFILES="etc/resolv.conf"

termux_step_make_install() {
	_RESOLV_CONF=$TERMUX_PREFIX/etc/resolv.conf
	printf "nameserver 8.8.8.8\nnameserver 8.8.4.4" > $_RESOLV_CONF
}
