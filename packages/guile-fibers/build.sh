TERMUX_PKG_HOMEPAGE=https://github.com/wingo/fibers
TERMUX_PKG_DESCRIPTION="Concurrent programming library for Guile"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://github.com/wingo/fibers/releases/download/v${TERMUX_PKG_VERSION}/fibers-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a5e1a9c49c0efe7ac6f355662041430d4b64e59baa538d2b8fb5ef7528d81dbf
TERMUX_PKG_DEPENDS="guile"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		make -j "$TERMUX_PKG_MAKE_PROCESSES"
		return
	fi
	make -j "$TERMUX_PKG_MAKE_PROCESSES" fibers-epoll.la
	mv .libs/fibers-epoll.so .libs/fibers-epoll.so.target
	gcc -shared -fPIC -DHAVE_CONFIG_H -I. -I/usr/include/guile/3.0 -I./extensions -o .libs/fibers-epoll.so extensions/epoll.c
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
	mv .libs/fibers-epoll.so.target .libs/fibers-epoll.so
}
