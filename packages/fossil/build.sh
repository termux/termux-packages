TERMUX_PKG_HOMEPAGE=https://www.fossil-scm.org
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=1.37
TERMUX_PKG_SRCURL=https://www.fossil-scm.org/index.html/uv/download/fossil-src-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DESCRIPTION="DSCM with built-in wiki, http interface and server, tickets database"
TERMUX_PKG_SHA256=81c19e81c4b2b60930bab3f2147b516525c855924ccc6d089748b0f5611be492
TERMUX_PKG_FOLDERNAME=Fossil_*
TERMUX_PKG_DEPENDS="libsqlite, openssl"

termux_step_pre_configure () {
	# for some ungodly reason, LDFLAGS isn't taken into consideration when
	# looking for libsqlite3. clang throws unused argument during compilation
	# because of this.
	CFLAGS="-L/data/data/com.termux/files/usr/lib"
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

