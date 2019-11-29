TERMUX_PKG_HOMEPAGE=https://www.haproxy.org/
TERMUX_PKG_DESCRIPTION="The Reliable, High Performance TCP/HTTP Load Balancer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.0.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://haproxy.org/download/${TERMUX_PKG_VERSION%.*}/src/haproxy-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c37e1e8515ad6f9781a0ac336ca88787f3bb52252fb2bdad9919ba16323c280a
TERMUX_PKG_DEPENDS="liblua, openssl, pcre, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

# USE_PCRE=1 requires libpcreposix which is not available. PCRE
# support will be disabled for now.
TERMUX_PKG_EXTRA_MAKE_ARGS="
CPU=generic
TARGET=generic
USE_GETADDRINFO=1
USE_OPENSSL=1
USE_ZLIB=1
USE_LUA=1
LUA_LIB_NAME=lua"

TERMUX_PKG_CONFFILES="etc/haproxy/haproxy.cfg"

termux_step_pre_configure() {
	if [ $TERMUX_PKG_API_LEVEL -ge 24 ]; then
		CC="$CC -Wl,-rpath=$TERMUX_PREFIX/lib -Wl,--enable-new-dtags"
	fi
}

termux_step_post_make_install() {
	for contrib in halog iprange ip6range; do
		make -C "contrib/$contrib" \
			CC="$CC"
			SBINDIR="$TERMUX_PREFIX/bin" \
			OPTIMIZE= \
			CFLAGS="$CFLAGS $CPPFLAGS" \
			LDFLAGS="$LDFLAGS"
		install -Dm700 "contrib/$contrib/$contrib" \
			"$TERMUX_PREFIX/bin/$contrib"
	done

	install -Dm600 "$TERMUX_PKG_BUILDER_DIR"/haproxy.cfg \
		"$TERMUX_PREFIX"/etc/haproxy/haproxy.cfg

	mkdir -p "$TERMUX_PREFIX"/share/haproxy/examples/errorfiles
	install -m600 examples/*.cfg "$TERMUX_PREFIX"/share/haproxy/examples/
	install -m600 examples/errorfiles/*.http \
		"$TERMUX_PREFIX"/share/haproxy/examples/errorfiles/
}
