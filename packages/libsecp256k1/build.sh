TERMUX_PKG_HOMEPAGE=https://github.com/bitcoin-core/secp256k1
TERMUX_PKG_DESCRIPTION="Optimized c library for ECDSA signatures and seret/public key operations on curve secp256k1"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.8.0"
TERMUX_PKG_SRCURL=https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=eb52b0e9239dff7dc26be5f9623567141b8720ec47da29eb3c1e0a660d17c8bb
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
