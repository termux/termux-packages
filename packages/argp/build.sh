TERMUX_PKG_HOMEPAGE=https://www.lysator.liu.se/~nisse/misc/
TERMUX_PKG_DESCRIPTION="Standalone version of arguments parsing functions from GLIBC"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SHA256=dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be
TERMUX_PKG_SRCURL=https://www.lysator.liu.se/~nisse/misc/argp-standalone-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_NO_DEVELSPLIT=true

termux_step_post_make_install() {
	cp libargp.a $TERMUX_PREFIX/lib
	cp $TERMUX_PKG_SRCDIR/argp.h $TERMUX_PREFIX/include
}
