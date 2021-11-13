TERMUX_PKG_HOMEPAGE=https://notmuchmail.org
TERMUX_PKG_DESCRIPTION="Thread-based email index, search and tagging system"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.32.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://notmuchmail.org/releases/notmuch-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8e0a7eb8ff2e6011ef48b2bf11d79b9c4bb74511cfe2987758b64898c2a2ded7
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
