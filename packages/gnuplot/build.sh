TERMUX_PKG_HOMEPAGE=http://gnuplot.info/
TERMUX_PKG_DESCRIPTION="Command-line driven graphing utility"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=5.2.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/gnuplot/gnuplot/${TERMUX_PKG_VERSION}/gnuplot-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=60a6764ccf404a1668c140f11cc1f699290ab70daa1151bb58fed6139a28ac37
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libiconv, readline, pango, libgd, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-x
--without-lua
--with-bitmap-terminals
--without-latex
"
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
