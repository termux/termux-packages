TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtasn1/
TERMUX_PKG_DESCRIPTION="This is GNU Libtasn1, a small ASN.1 library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.19.0
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/libtasn1/libtasn1-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1613f0ac1cf484d6ec0ce3b8c06d56263cc7242f1c23b30d82d23de345a63f7a

termux_step_pre_configure() {
	autoreconf -fi
}
