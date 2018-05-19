TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="A Content-Preserving PDF Transformation System"
TERMUX_PKG_VERSION=8.0.2
TERMUX_PKG_SHA256=87d585ad59baffe32cf7555aac4dbfde3ab1b1f3d7e2d4ca3916d1599113ee6e
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/archive/release-qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	autoreconf -fi
}
