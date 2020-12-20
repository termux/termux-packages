TERMUX_PKG_HOMEPAGE=https://github.com/jmacd/xdelta
TERMUX_PKG_DESCRIPTION='xdelta3 - VCDIFF (RFC 3284) binary diff tool'
TERMUX_PKG_LICENSE=Apache-2.0
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_SRCURL=https://github.com/jmacd/xdelta/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7515cf5378fca287a57f4e2fee1094aabc79569cfe60d91e06021a8fd7bae29d
TERMUX_PKG_DEPENDS=liblzma

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+=/xdelta3
}

termux_step_pre_configure() {
	autoreconf --install
}
