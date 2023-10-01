TERMUX_PKG_HOMEPAGE=https://github.com/stefanberger/swtpm
TERMUX_PKG_DESCRIPTION="Software TPM Emulator"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.1"
TERMUX_PKG_SRCURL=https://github.com/stefanberger/swtpm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7bba52aa41090f75087034fac5fe8daed10c3e7e7234df7c9558849318927f41
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, json-glib, libseccomp, libtpms, openssl"
TERMUX_PKG_BUILD_DEPENDS="libtasn1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-openssl
--without-gnutls
"

termux_step_pre_configure() {
	autoreconf -fi

	CPPFLAGS+=" -Dindex=strchr"
}
