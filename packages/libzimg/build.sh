TERMUX_PKG_HOMEPAGE=https://github.com/sekrit-twc/zimg
TERMUX_PKG_DESCRIPTION="Scaling, colorspace conversion, and dithering library"
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.6"
TERMUX_PKG_SRCURL=https://github.com/sekrit-twc/zimg/archive/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=be89390f13a5c9b2388ce0f44a5e89364a20c1c57ce46d382b1fcc3967057577
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
