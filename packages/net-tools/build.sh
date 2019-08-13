TERMUX_PKG_HOMEPAGE=http://net-tools.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Configuration tools for Linux networking"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.60.2017.02.21
TERMUX_PKG_REVISION=2
local commit=479bb4a7e11a4084e2935c0a576388f92469225b
TERMUX_PKG_SHA256=7e9f8e8dcbabed0c8eeb976100496567abae7ac9d92c72cebd1a9d965473e943
# We use a mirror to avoid using
# https://sourceforge.net/code-snapshots/git/n/ne/net-tools/code.git/net-tools-code-$commit.zip
# which does not work all the time (sourceforge caching system):
TERMUX_PKG_SRCURL=https://dl.bintray.com/termux/upstream/net-tools-code-${commit}.zip
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="BINDIR=$TERMUX_PREFIX/bin SBINDIR=$TERMUX_PREFIX/bin HAVE_HOSTNAME_TOOLS=0"

termux_step_configure() {
	CFLAGS="$CFLAGS -D_LINUX_IN6_H -Dindex=strchr -Drindex=strrchr"
	export LDLIBS="-llog"
	sed -i "s#/usr#$TERMUX_PREFIX#" $TERMUX_PKG_SRCDIR/man/Makefile
	yes "" | make config || true
}

termux_step_make_install() {
	make $TERMUX_PKG_EXTRA_MAKE_ARGS update
}
