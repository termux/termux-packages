TERMUX_PKG_HOMEPAGE=http://www.muchsync.org/
TERMUX_PKG_DESCRIPTION="synchronize notmuch mail across machines"
TERMUX_PKG_LICENSE="GPL2"
TERMUX_PKG_VERSION=5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=www.muchsync.org/src/muchsync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b0afc2ce2dca636ae318659452902e26ac804d1b8b1982e74dbc4222f2155cc
TERMUX_PKG_DEPENDS="libc++, notmuch, libxapian, libsqlite, openssl"

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

