TERMUX_PKG_HOMEPAGE=https://notmuchmail.org
TERMUX_PKG_DESCRIPTION="Thread-based email index, search and tagging system"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.37
TERMUX_PKG_SRCURL=https://notmuchmail.org/releases/notmuch-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0e766df28b78bf4eb8235626ab1f52f04f1e366649325a8ce8d3c908602786f6
TERMUX_PKG_DEPENDS="glib, libc++, libgmime, libtalloc, libxapian, zlib"
TERMUX_PKG_BREAKS="notmuch-dev"
TERMUX_PKG_REPLACES="notmuch-dev"
TERMUX_PKG_BUILD_IN_SRC=true

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
