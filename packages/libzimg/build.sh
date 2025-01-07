TERMUX_PKG_HOMEPAGE=https://github.com/sekrit-twc/zimg
TERMUX_PKG_DESCRIPTION="Scaling, colorspace conversion, and dithering library"
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.5
TERMUX_PKG_SRCURL=https://github.com/sekrit-twc/zimg/archive/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a9a0226bf85e0d83c41a8ebe4e3e690e1348682f6a2a7838f1b8cbff1b799bcf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
