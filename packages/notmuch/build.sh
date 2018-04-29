TERMUX_PKG_HOMEPAGE=https://notmuchmail.org
TERMUX_PKG_DESCRIPTION="Thread-based email index, search and tagging system"
TERMUX_PKG_VERSION=0.26.2
TERMUX_PKG_SHA256=109c1865db7a035d08707421d13e9b6b82ee8e9f1534db70c28c51bc39370e3b
TERMUX_PKG_SRCURL=https://notmuchmail.org/releases/notmuch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="glib, libgmime, libtalloc, libxapian"

termux_step_configure () {
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
