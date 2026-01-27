TERMUX_PKG_HOMEPAGE=https://github.com/bitcoin-core/secp256k1
TERMUX_PKG_DESCRIPTION="Optimized c library for ECDSA signatures and seret/public key operations on curve secp256k1"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.7.1"
TERMUX_PKG_SRCURL=https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=958f204dbafc117e73a2604285dc2eb2a5128344d3499c114dcba5de54cb7a9e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# These flags are suggested by electrum
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-module-recovery
--enable-experimental
--enable-module-ecdh
"

termux_step_pre_configure() {
	autoreconf -vfi
}
