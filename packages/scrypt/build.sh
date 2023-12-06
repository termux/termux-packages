TERMUX_PKG_HOMEPAGE=https://www.tarsnap.com/scrypt.html
TERMUX_PKG_DESCRIPTION="scrypt KDF library and file encryption tool"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.tarsnap.com/scrypt/scrypt-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=d632c1193420ac6faebf9482e65e33d3a5664eccd643b09a509d21d1c1f29be2
TERMUX_PKG_DEPENDS="openssl"

termux_step_pre_configure() {
	sed -i '/# Detect specific ARM features/,$d' $TERMUX_PKG_SRCDIR/libcperciva/cpusupport/Build/cpusupport.sh
}
