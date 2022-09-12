TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="Content-Preserving PDF Transformation System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=11.0.0
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/releases/download/v$TERMUX_PKG_VERSION/qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8d99e98893f68f52ca3b579770e7e6f4c96612084d6a0e7e05854a6d631b8fe6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, zlib"
TERMUX_PKG_BREAKS="qpdf-dev"
TERMUX_PKG_REPLACES="qpdf-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DRANDOM_DEVICE=/dev/urandom"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
