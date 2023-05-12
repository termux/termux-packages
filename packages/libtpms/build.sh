TERMUX_PKG_HOMEPAGE=https://github.com/stefanberger/libtpms
TERMUX_PKG_DESCRIPTION="Provides software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.6
TERMUX_PKG_SRCURL=https://github.com/stefanberger/libtpms/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2807466f1563ebe45fdd12dd26e501e8a0c4fbb99c7c428fbb508789efd221c0
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-openssl
"

termux_step_pre_configure() {
	autoreconf -fi
}
