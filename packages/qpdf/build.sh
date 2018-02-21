TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="A Content-Preserving PDF Transformation System"
TERMUX_PKG_VERSION=7.1.1
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/archive/release-qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=21822dc365eaee55bc449d84eb760b9845c4871783ab0e4c4f3b244052718a1a
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	autoreconf -fi
}
