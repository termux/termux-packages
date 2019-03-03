TERMUX_PKG_HOMEPAGE=https://notmuchmail.org
TERMUX_PKG_DESCRIPTION="Thread-based email index, search and tagging system"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.28.2
TERMUX_PKG_SHA256=85a6498033451e188bcebbb3a4841e77c8d07b7fb1db89f17a74d6038f73e931
TERMUX_PKG_SRCURL=https://notmuchmail.org/releases/notmuch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="glib, libgmime, libtalloc, libxapian"

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
