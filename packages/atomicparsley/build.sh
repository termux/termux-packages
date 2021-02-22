TERMUX_PKG_HOMEPAGE=https://github.com/wez/atomicparsley
TERMUX_PKG_DESCRIPTION="Read, parse and set metadata of MPEG-4 and 3gp files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:20210114.184825.1dbe1be
TERMUX_PKG_SRCURL=https://github.com/wez/atomicparsley/archive/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=8877262c86d0ad231a5b0eaa8ab9c0c1d4e06fafea0b96a819d9a5e565a28b8c
TERMUX_PKG_DEPENDS="libc++, zlib"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin AtomicParsley
}
