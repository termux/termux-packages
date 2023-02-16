TERMUX_PKG_HOMEPAGE=https://github.com/nu774/fdkaac
TERMUX_PKG_DESCRIPTION="command line encoder frontend for libfdk-aac"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@DLC01"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_SRCURL=https://github.com/nu774/fdkaac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=87b2d2cc913a1f90bd19315061ede81c1c3364e160802c70117a7ea81e80bd33
TERMUX_PKG_DEPENDS="libfdk-aac"

termux_step_pre_configure() {
	autoreconf -fi
}
