TERMUX_PKG_HOMEPAGE=http://gnuplot.info/
TERMUX_PKG_DESCRIPTION="Command-line driven graphing utility"
TERMUX_PKG_VERSION=5.2.4
TERMUX_PKG_SHA256=1515f000bd373aaa53b16183f274189d4f5e0ae47d22f434857933d16a4770cb
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/gnuplot/gnuplot/${TERMUX_PKG_VERSION}/gnuplot-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x --with-lua=no --with-bitmap-terminals"
TERMUX_PKG_DEPENDS="libandroid-support, readline, pango, libgd"
