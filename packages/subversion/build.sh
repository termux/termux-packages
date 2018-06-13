TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_SHA256=2cf23f3abb837dea0585a6b0ebd70e80e01f95bddef7c1aa097c18e3eaa6b584
TERMUX_PKG_SRCURL=https://www.apache.org/dist/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite, liblz4, utf8proc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl --without-libmagic"

termux_step_pre_configure() {
	CFLAGS+=" -std=c11"
}
