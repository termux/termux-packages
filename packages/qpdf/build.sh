TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="A Content-Preserving PDF Transformation System"
TERMUX_PKG_VERSION=7.0.0
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/archive/release-qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a599c1118c42b2300c27b95c86d005dedf5901f3b60c324c968296126b15594f
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	autoreconf -fi
}
