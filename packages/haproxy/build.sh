TERMUX_PKG_HOMEPAGE=http://www.haproxy.org/
TERMUX_PKG_DESCRIPTION="The Reliable, High Performance TCP/HTTP Load Balancer"
TERMUX_PKG_VERSION=1.8.2
TERMUX_PKG_SRCURL=https://www.haproxy.org/download/1.8/src/haproxy-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_MAKE_ARGS="TARGET=generic"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	return
}
