TERMUX_PKG_HOMEPAGE=http://qpdf.sourceforge.net
TERMUX_PKG_DESCRIPTION="Content-Preserving PDF Transformation System"
TERMUX_PKG_VERSION=8.1.0
TERMUX_PKG_SHA256=cb9c3fbad2cbe322ae7670c28fde7fc1ff0cd66785d83fa3759dd9bffec47018
TERMUX_PKG_SRCURL=https://github.com/qpdf/qpdf/archive/release-qpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-random=/dev/urandom"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	autoreconf -fi
}
