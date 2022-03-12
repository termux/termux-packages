TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="Content-Preserving PDF Transformation System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.6.3
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/releases/download/release-qpdf-$TERMUX_PKG_VERSION/qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e8fc23b2a584ea68c963a897515d3eb3129186741dd19d13c86d31fa33493811
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, zlib"
TERMUX_PKG_BREAKS="qpdf-dev"
TERMUX_PKG_REPLACES="qpdf-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"

termux_step_pre_configure() {
	./autogen.sh
}
