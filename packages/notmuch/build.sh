TERMUX_PKG_HOMEPAGE=https://notmuchmail.org
TERMUX_PKG_DESCRIPTION="Thread-based email index, search and tagging system"
TERMUX_PKG_VERSION=0.24.1
TERMUX_PKG_SRCURL=https://notmuchmail.org/releases/notmuch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fa117de2c6096dd896a333b9c770572a939e04a02abe6745b6b07f5363063ca3
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="glib, libgmime, libtalloc, libxapian"

termux_step_configure () {
	cd $TERMUX_PKG_SRCDIR
	XAPIAN_CONFIG=$TERMUX_PREFIX/bin/xapian-config ./configure \
		--prefix=$TERMUX_PREFIX \
		--without-api-docs \
		--without-desktop \
		--without-emacs \
		--without-ruby
}
