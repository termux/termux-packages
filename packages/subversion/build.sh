TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_VERSION=1.9.5
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8a4fc68aff1d18dcb4dd9e460648d24d9e98657fbed496c582929c6b3ce555e5
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl --without-libmagic"

termux_step_pre_configure() {
	CPPFLAGS+=" -std=c11"
}
