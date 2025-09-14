TERMUX_PKG_HOMEPAGE=https://github.com/stefanberger/libtpms
TERMUX_PKG_DESCRIPTION="Provides software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/stefanberger/libtpms/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ebc24f3191d90f6cf0b4d4200cd876db4bd224b3c565708bbea0a82ee275e0fb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-openssl
--with-tpm2
"

termux_step_pre_configure() {
	autoreconf -fi
	CPPFLAGS+=" -Dindex=strchr"
}
