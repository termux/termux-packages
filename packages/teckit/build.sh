TERMUX_PKG_HOMEPAGE=http://scripts.sil.org/teckitdownloads
TERMUX_PKG_DESCRIPTION="TECkit is a library for encoding conversion"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.5.7
TERMUX_PKG_SHA256="d6a820b201b1a8f369a3002975d30fd96a01d9af3119514121e4d793daeb88c4"
TERMUX_PKG_SRCURL="https://github.com/silnrsi/teckit/archive/v$TERMUX_PKG_VERSION.tar.gz"

termux_step_pre_configure() {
	./autogen.sh
}
