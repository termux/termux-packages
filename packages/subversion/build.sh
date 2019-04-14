TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.11.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=9efd2750ca4d72ec903431a24b9c732b6cbb84aad9b7563f59dd96dea5be60bb
TERMUX_PKG_SRCURL=https://www.apache.org/dist/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite, liblz4, utf8proc, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl --without-libmagic"

termux_step_pre_configure() {
	CFLAGS+=" -std=c11"
}
