TERMUX_PKG_HOMEPAGE=http://net-tools.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Configuration tools for Linux networking"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.10.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/net-tools/files/net-tools-2.10.tar.xz
TERMUX_PKG_SHA256=b262435a5241e89bfa51c3cabd5133753952f7a7b7b93f32e08cb9d96f580d69
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="BINDIR=$TERMUX_PREFIX/bin SBINDIR=$TERMUX_PREFIX/bin HAVE_HOSTNAME_TOOLS=0"

termux_step_configure() {
	CFLAGS="$CFLAGS -D_LINUX_IN6_H -Dindex=strchr -Drindex=strrchr"
	sed -i "s#/usr#$TERMUX_PREFIX#" $TERMUX_PKG_SRCDIR/man/Makefile
	yes "" | make config || true
}
