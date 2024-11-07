TERMUX_PKG_HOMEPAGE=https://www.fossil-scm.org
TERMUX_PKG_DESCRIPTION="DSCM with built-in wiki, http interface and server, tickets database"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT-BSD2.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.25"
TERMUX_PKG_SRCURL=https://www.fossil-scm.org/home/tarball/version-$TERMUX_PKG_VERSION/fossil-src-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=611cfa50d08899eb993a5f475f988b4512366cded82688c906cf913e5191b525
TERMUX_PKG_AUTO_UPDATE=true
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
		--with-sqlite=$TERMUX_PREFIX \
		--with-openssl=$TERMUX_PREFIX \
		--with-zlib=$TERMUX_PREFIX
}
