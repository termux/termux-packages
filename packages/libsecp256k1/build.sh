TERMUX_PKG_HOMEPAGE=https://github.com/bitcoin-core/secp256k1
TERMUX_PKG_DESCRIPTION="Optimized c library for ECDSA signatures and seret/public key operations on curve secp256k1"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20200902
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/bitcoin-core/secp256k1/archive/f49c9896b0d03d7dc45515260760659879c5728e.tar.gz
TERMUX_PKG_SHA256=941b63f4d35ff231f477e96b738759c4943731183c3cf8a586768c1010315882
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
