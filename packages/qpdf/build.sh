TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="Content-Preserving PDF Transformation System"
TERMUX_PKG_VERSION=8.2.1
TERMUX_PKG_SHA256=f61319dbb44ca45f3a200bd59e8a86a906b61e2d223b104d9d2fbddcab9100ab
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/archive/release-qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	autoreconf -fi
}
