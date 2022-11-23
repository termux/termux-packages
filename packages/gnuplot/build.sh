TERMUX_PKG_HOMEPAGE=http://gnuplot.info/
TERMUX_PKG_DESCRIPTION="Command-line driven graphing utility"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4.5
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/gnuplot/gnuplot/${TERMUX_PKG_VERSION}/gnuplot-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=66f679115dd30559e110498fc94d926949d4d370b4999a042e724b8e910ee478
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcairo, libgd, libiconv, libx11, pango, readline"
TERMUX_PKG_BREAKS="gnuplot-x"
TERMUX_PKG_REPLACES="gnuplot-x"
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-x
--without-lua
--with-bitmap-terminals
--without-latex
ac_cv_search_iconv_open=-liconv
"

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR/configure"
	make -C docs/ gnuplot.gih
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/gnuplot/${TERMUX_PKG_VERSION:0:3}/

	cp $TERMUX_PKG_HOSTBUILD_DIR/docs/gnuplot.gih \
	   $TERMUX_PREFIX/share/gnuplot/${TERMUX_PKG_VERSION:0:3}/gnuplot.gih
}
