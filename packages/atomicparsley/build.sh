TERMUX_PKG_HOMEPAGE=https://github.com/wez/atomicparsley
TERMUX_PKG_DESCRIPTION="Read, parse and set metadata of MPEG-4 and 3gp files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1:20200701.154658.b0d6223
TERMUX_PKG_SRCURL=https://github.com/wez/atomicparsley/archive/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=52f11dc0cbd8964fcdaf019bfada2102f9ee716a1d480cd43ae5925b4361c834
TERMUX_PKG_DEPENDS="libc++, zlib"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin AtomicParsley
}
