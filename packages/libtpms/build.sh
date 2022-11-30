TERMUX_PKG_HOMEPAGE=https://github.com/stefanberger/libtpms
TERMUX_PKG_DESCRIPTION="Provides software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.5
TERMUX_PKG_SRCURL=https://github.com/stefanberger/libtpms/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9522c69001e46a3b0e1ccd646d36db611b2366c395099d29037f2b067bf1bc60
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-openssl
"

termux_step_pre_configure() {
	autoreconf -fi
}
