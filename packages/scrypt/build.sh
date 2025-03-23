TERMUX_PKG_HOMEPAGE=https://www.tarsnap.com/scrypt.html
TERMUX_PKG_DESCRIPTION="scrypt KDF library and file encryption tool"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.1"
TERMUX_PKG_SRCURL=https://www.tarsnap.com/scrypt/scrypt-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=df2f23197c9589963267f85f9c5307ecf2b35a98b83a551bf1b1fb7a4d06d4c2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"

termux_step_pre_configure() {
	sed -i '/# Detect specific ARM features/,$d' $TERMUX_PKG_SRCDIR/libcperciva/cpusupport/Build/cpusupport.sh
}
