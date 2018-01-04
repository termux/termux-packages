TERMUX_PKG_HOMEPAGE=http://www.haproxy.org/
TERMUX_PKG_DESCRIPTION="The Reliable, High Performance TCP/HTTP Load Balancer"
TERMUX_PKG_VERSION=1.8.3
TERMUX_PKG_SRCURL=https://www.haproxy.org/download/1.8/src/haproxy-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3dc7f65c4ed6ac1420dfd01896833e0f765f72471fbfa316a195793272e58b4a
TERMUX_PKG_EXTRA_MAKE_ARGS="TARGET=generic"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	return
}
