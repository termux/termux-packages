TERMUX_PKG_HOMEPAGE=https://notmuchmail.org
TERMUX_PKG_DESCRIPTION="Thread-based email index, search and tagging system"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.28.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://notmuchmail.org/releases/notmuch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bab1cabb0542ce2bd4b41a15b84a8d81c8dc3332162705ded6f311dd898656ca
TERMUX_PKG_DEPENDS="glib, libc++, libgmime, libtalloc, libxapian, zlib"
TERMUX_PKG_BUILD_IN_SRC=yes

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
