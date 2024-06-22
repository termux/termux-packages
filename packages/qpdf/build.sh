TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="Content-Preserving PDF Transformation System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="11.9.1"
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/releases/download/v$TERMUX_PKG_VERSION/qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2ba4d248f9567a27c146b9772ef5dc93bd9622317978455ffe91b259340d13d1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, zlib"
TERMUX_PKG_BREAKS="qpdf-dev"
TERMUX_PKG_REPLACES="qpdf-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DRANDOM_DEVICE=/dev/urandom"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
