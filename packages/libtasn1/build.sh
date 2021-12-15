TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtasn1/
TERMUX_PKG_DESCRIPTION="This is GNU Libtasn1, a small ASN.1 library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.0
TERMUX_PKG_SRCURL=https://gitlab.com/gnutls/libtasn1.git

termux_step_post_get_source() {
	./bootstrap
}
