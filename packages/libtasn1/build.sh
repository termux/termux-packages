TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtasn1/
TERMUX_PKG_DESCRIPTION="This is GNU Libtasn1, a small ASN.1 library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=4_16_0
TERMUX_PKG_SRCURL=https://gitlab.com/gnutls/libtasn1/-/archive/libtasn1_${TERMUX_PKG_VERSION}/libtasn1-libtasn1_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2d1b0cbd26edfcb54694b2339106a02a81d630a7dedc357461aeb186874cc7c0
TERMUX_PKG_BUILD_DEPENDS="texinfo, help2man"

termux_step_post_get_source {
./bootstrap
}
