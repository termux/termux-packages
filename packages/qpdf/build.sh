TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="Content-Preserving PDF Transformation System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=8.4.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=71d9b6c77ac56521d86a481cb9e52c0774de106c1dcf7a0644a05bd1230be87e
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/archive/release-qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo, zlib"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
