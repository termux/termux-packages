TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="Content-Preserving PDF Transformation System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=10.0.4
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/releases/download/release-qpdf-$TERMUX_PKG_VERSION/qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b191dc4af4ea4630cdc404a4ee95a0f21c12f56ecc4ae045f04425464d7c696e
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, zlib"
TERMUX_PKG_BREAKS="qpdf-dev"
TERMUX_PKG_REPLACES="qpdf-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"

termux_step_pre_configure() {
	./autogen.sh
}
