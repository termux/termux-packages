TERMUX_PKG_HOMEPAGE=https://www.fossil-scm.org
TERMUX_PKG_DESCRIPTION="DSCM with built-in wiki, http interface and server, tickets database"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT-BSD2.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.16
TERMUX_PKG_SRCURL=https://fossil-scm.org/home/tarball/7aedd5675883d4412cf20917d340b6985e3ecb842e88a39f135df034b2d5f4d3/fossil-src-2.16.tar.gz
TERMUX_PKG_SHA256=fab37e8093932b06b586e99a792bf9b20d00d530764b5bddb1d9a63c8cdafa14
TERMUX_PKG_DEPENDS="libsqlite, openssl, zlib"

termux_step_pre_configure() {
	# Avoid mixup of flags between cross compilation
	# and native build.
	CC="$CC $CPPFLAGS $CFLAGS $LDFLAGS"
	unset CFLAGS LDFLAGS
}

termux_step_configure() {
	$TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		--host=$TERMUX_HOST_PLATFORM \
		--json \
		--disable-internal-sqlite \
		--with-openssl=$TERMUX_PREFIX \
		--with-zlib=$TERMUX_PREFIX
}
