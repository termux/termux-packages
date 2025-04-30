TERMUX_PKG_HOMEPAGE=https://github.com/stefanberger/swtpm
TERMUX_PKG_DESCRIPTION="Software TPM Emulator"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_SRCURL=https://github.com/stefanberger/swtpm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f8da11cadfed27e26d26c5f58a7b8f2d14d684e691927348906b5891f525c684
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

termux_step_post_massage() {
	rm -r "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/libexec/installed-tests
}
