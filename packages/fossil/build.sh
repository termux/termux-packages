TERMUX_PKG_HOMEPAGE=https://www.fossil-scm.org
TERMUX_PKG_DESCRIPTION="DSCM with built-in wiki, http interface and server, tickets database"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT-BSD2.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.26"
TERMUX_PKG_SRCURL=https://www.fossil-scm.org/home/tarball/version-$TERMUX_PKG_VERSION/fossil-src-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a9be104c8055ada40985a158392d73f3c84829accb5b5d404e361fea360774c2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, zlib"

termux_step_pre_configure() {
	# Avoid mixup of flags between cross compilation
	# and native build.
	CC="$CC $CPPFLAGS $CFLAGS $LDFLAGS"
	unset CFLAGS LDFLAGS
}

termux_step_configure() {
	# DO NOT add --disable-internal-sqlite, otherwise fossil panics >_<
	$TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		--host=$TERMUX_HOST_PLATFORM \
		--json \
		--with-openssl=$TERMUX_PREFIX \
		--with-zlib=$TERMUX_PREFIX
}
