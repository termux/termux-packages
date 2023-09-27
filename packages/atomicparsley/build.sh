TERMUX_PKG_HOMEPAGE=https://github.com/wez/atomicparsley
TERMUX_PKG_DESCRIPTION="Read, parse and set metadata of MPEG-4 and 3gp files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:20221229.172126.d813aa6"
TERMUX_PKG_SRCURL=https://github.com/wez/atomicparsley/archive/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=2f095a251167dc771e8f4434abe4a9c7af7d8e13c718fb8439a0e0d97078899b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zlib"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin AtomicParsley
}
