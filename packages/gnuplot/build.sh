TERMUX_PKG_HOMEPAGE=http://gnuplot.info/
TERMUX_PKG_DESCRIPTION="Command-line driven graphing utility"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=5.2.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/gnuplot/gnuplot/${TERMUX_PKG_VERSION}/gnuplot-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=97fe503ff3b2e356fe2ae32203fc7fd2cf9cef1f46b60fe46dc501a228b9f4ed
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libiconv, readline, pango, libgd, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x --with-lua=no --with-bitmap-terminals"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR/configure"
	make -C docs/ gnuplot.gih
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/gnuplot/5.2/

	cp $TERMUX_PKG_HOSTBUILD_DIR/docs/gnuplot.gih \
	   $TERMUX_PREFIX/share/gnuplot/5.2/gnuplot.gih
}
