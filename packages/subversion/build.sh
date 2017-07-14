TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_VERSION=1.9.6
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=dbcbc51fb634082f009121f2cb64350ce32146612787ffb0f7ced351aacaae19
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl --without-libmagic"

termux_step_pre_configure() {
	CPPFLAGS+=" -std=c11"
}
