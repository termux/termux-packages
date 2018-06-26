TERMUX_PKG_HOMEPAGE=http://gnuplot.info/
TERMUX_PKG_DESCRIPTION="Command-line driven graphing utility"
TERMUX_PKG_VERSION=5.2.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=feb58c9358d9d129e00507f3b34d4b13c4caea3f004325c587f8caafe5dbe724
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/gnuplot/gnuplot/${TERMUX_PKG_VERSION}/gnuplot-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x --with-lua=no --with-bitmap-terminals"
TERMUX_PKG_DEPENDS="libandroid-support, readline, pango, libgd"
