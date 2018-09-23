TERMUX_PKG_HOMEPAGE=https://www.fossil-scm.org
TERMUX_PKG_DESCRIPTION="DSCM with built-in wiki, http interface and server, tickets database"
TERMUX_PKG_API_LEVEL=23
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=2.7
TERMUX_PKG_SHA256=2c24359131d7495e47dc95021eb35f1ba408ded9087e36370d94742a4011033c
TERMUX_PKG_SRCURL=https://www.fossil-scm.org/index.html/uv/fossil-src-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libsqlite, openssl"

termux_step_pre_configure () {
	# Avoid mixup of flags between cross compilation
	# and native build.
	CC="$CC $CFLAGS $LDFLAGS"
	unset CFLAGS LDFLAGS
}

termux_step_configure () {
	$TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		--host=$TERMUX_HOST_PLATFORM \
		--json \
		--disable-internal-sqlite \
		--with-openssl=$TERMUX_PREFIX \
		--with-zlib=auto
}

