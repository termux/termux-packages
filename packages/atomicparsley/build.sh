TERMUX_PKG_HOMEPAGE=https://github.com/wez/atomicparsley
TERMUX_PKG_DESCRIPTION="Read, parse and set metadata of MPEG-4 and 3gp files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:20240608.083822.1ed9031"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/wez/atomicparsley/archive/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=5bc9ac931a637ced65543094fa02f50dde74daae6c8800a63805719d65e5145e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++, zlib"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin AtomicParsley
}
