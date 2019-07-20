TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="Content-Preserving PDF Transformation System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=8.4.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/archive/release-qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=741a171295e561eadf0285ae6b0b821632f9773b8db0daa95df4dc565bf566bb
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, zlib"
TERMUX_PKG_BREAKS="qpdf-dev"
TERMUX_PKG_REPLACES="qpdf-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"

termux_step_pre_configure() {
	./autogen.sh
}
