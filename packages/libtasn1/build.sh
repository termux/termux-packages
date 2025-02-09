TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtasn1/
TERMUX_PKG_DESCRIPTION="This is GNU Libtasn1, a small ASN.1 library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/libtasn1/libtasn1-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=92e0e3bd4c02d4aeee76036b2ddd83f0c732ba4cda5cb71d583272b23587a76c
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -fi
}
