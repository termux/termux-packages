TERMUX_PKG_HOMEPAGE=https://www.fossil-scm.org
TERMUX_PKG_DESCRIPTION='DSCM with built-in wiki, http interface and server, tickets database'
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_VERSION=1.37
TERMUX_PKG_SRCURL=http://www.fossil-scm.org/fossil/uv/download/fossil-src-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81c19e81c4b2b60930bab3f2147b516525c855924ccc6d089748b0f5611be492
TERMUX_PKG_FOLDERNAME=Fossil_2017-01-16_205854_1669115ab9
TERMUX_PKG_DEPENDS='libsqlite, openssl'

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

