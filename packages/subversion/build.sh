TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_VERSION=1.9.7
TERMUX_PKG_SRCURL=https://www.apache.org/dist/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c3b118333ce12e501d509e66bb0a47bcc34d053990acab45559431ac3e491623
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl --without-libmagic"

termux_step_pre_configure() {
	CPPFLAGS+=" -std=c11"
}
