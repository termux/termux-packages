TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtasn1/
TERMUX_PKG_DESCRIPTION="This is GNU Libtasn1, a small ASN.1 library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.16.0
TERMUX_PKG_SRCURL=https://gitlab.com/gnutls/libtasn1/-/archive/libtasn1_${TERMUX_PKG_VERSION//./_}/libtasn1-libtasn1_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=4032d6ba64b5d378aba80b777feb1d8b367b5bcd8270f43c7a566a247008c539

TERMUX_PKG_BUILD_DEPENDS="git, texinfo, help2man"

termux_step_post_get_source() {
  ./bootstrap
}
