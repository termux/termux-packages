TERMUX_PKG_HOMEPAGE=https://github.com/wez/atomicparsley
TERMUX_PKG_DESCRIPTION="Read, parse and set metadata of MPEG-4 and 3gp files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:20210124.204813.840499f
TERMUX_PKG_SRCURL=https://github.com/wez/atomicparsley/archive/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=21e6eb6791b63ba1d06c6ffa9cf40ee81cec80da944e8a29c6dbd11d9de50b28
TERMUX_PKG_DEPENDS="libc++, zlib"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin AtomicParsley
}
