TERMUX_PKG_HOMEPAGE=https://github.com/stefanberger/swtpm
TERMUX_PKG_DESCRIPTION="Software TPM Emulator"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.0"
TERMUX_PKG_SRCURL=https://github.com/stefanberger/swtpm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f10ae0d3123ab05c3808f8c8d39f633cf1a0cf142d6ac9b87b8364a682ac842
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
