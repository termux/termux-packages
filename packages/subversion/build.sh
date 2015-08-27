TERMUX_PKG_HOMEPAGE=http://subversion.apache.org/
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl --without-libmagic"
