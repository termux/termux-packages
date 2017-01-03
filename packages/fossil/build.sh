TERMUX_PKG_HOMEPAGE=https://www.fossil-scm.org
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_VERSION=1.36
TERMUX_PKG_SRCURL=https://www.fossil-scm.org/index.html/uv/download/fossil-src-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DESCRIPTION='DSCM with built-in wiki, http interface and server, tickets database'
TERMUX_PKG_SHA256=2676c35ec5e44099a3522e7e9f1d1f84a9338db4457618d5338cb6826d0dfd12
TERMUX_PKG_FOLDERNAME=fossil-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS='libsqlite, openssl'

termux_step_pre_configure () {
	# for some unknown reason LDFLAGS aren't picked up from env
	CFLAGS="$CFLAGS $LDFLAGS"
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

