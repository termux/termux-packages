TERMUX_PKG_HOMEPAGE=http://net-tools.sourceforge.net/
TERMUX_PKG_VERSION=1.60.2017.02.21
TERMUX_PKG_DESCRIPTION="Configuration tools for Linux networking"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="BINDIR=$TERMUX_PREFIX/bin SBINDIR=$TERMUX_PREFIX/bin HAVE_HOSTNAME_TOOLS=0"

termux_step_post_extract_package () {
	local _commit=479bb4a7e11a4084e2935c0a576388f92469225b
	git clone git://git.code.sf.net/p/net-tools/code .
	git checkout 479bb4a7e11a4084e2935c0a576388f92469225b
}

termux_step_configure () {
	CFLAGS="$CFLAGS -D_LINUX_IN6_H -Dindex=strchr -Drindex=strrchr"
	LDFLAGS="$LDFLAGS -llog"
	sed -i "s#/usr#$TERMUX_PREFIX#" $TERMUX_PKG_SRCDIR/man/Makefile
	yes "" | make config || true
}

termux_step_make_install () {
	make $TERMUX_PKG_EXTRA_MAKE_ARGS update
}
