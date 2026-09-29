TERMUX_PKG_HOMEPAGE=https://www.tarsnap.com/scrypt.html
TERMUX_PKG_DESCRIPTION="scrypt KDF library and file encryption tool"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.tarsnap.com/scrypt/scrypt-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=1c2710517e998eaac2e97db11f092e37139e69886b21a1b2661f64e130215ae9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"

termux_step_pre_configure() {
	sed -i '/# Detect specific ARM features/,$d' $TERMUX_PKG_SRCDIR/libcperciva/cpusupport/Build/cpusupport.sh
}
