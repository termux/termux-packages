TERMUX_PKG_HOMEPAGE=https://notmuchmail.org
TERMUX_PKG_DESCRIPTION="Thread-based email index, search and tagging system"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.28.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=4e212d8b4ae30da04edb05d836dcdb569488ff6760706cecb882488eb1710eec
TERMUX_PKG_SRCURL=https://notmuchmail.org/releases/notmuch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="glib, libgmime, libtalloc, libxapian, zlib"

termux_step_configure() {
	# Use python3 so that the python3-sphinx package is
	# found for man page generation.
	export PYTHON=python3

	cd $TERMUX_PKG_SRCDIR
	XAPIAN_CONFIG=$TERMUX_PREFIX/bin/xapian-config ./configure \
		--prefix=$TERMUX_PREFIX \
		--without-api-docs \
		--without-desktop \
		--without-emacs \
		--without-ruby
}
