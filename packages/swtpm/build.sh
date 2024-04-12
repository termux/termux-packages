TERMUX_PKG_HOMEPAGE=https://github.com/stefanberger/swtpm
TERMUX_PKG_DESCRIPTION="Software TPM Emulator"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.2"
TERMUX_PKG_SRCURL=https://github.com/stefanberger/swtpm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b281b4e8c39f68e1928675f788abc70072e4081152e129144359a8c5c304c06b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, json-glib, libseccomp, libtpms, openssl"
TERMUX_PKG_BUILD_DEPENDS="libtasn1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-openssl
--without-gnutls
--disable-tests
"

termux_step_pre_configure() {
	autoreconf -fi

	CPPFLAGS+=" -Dindex=strchr"
}
