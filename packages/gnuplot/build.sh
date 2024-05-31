TERMUX_PKG_HOMEPAGE=http://gnuplot.info/
TERMUX_PKG_DESCRIPTION="Command-line driven graphing utility"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.0.1"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/gnuplot/gnuplot/${TERMUX_PKG_VERSION}/gnuplot-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e85a660c1a2a1808ff24f7e69981ffcbac66a45c9dcf711b65610b26ea71379a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcairo, libgd, libiconv, libx11, pango, readline"
TERMUX_PKG_BREAKS="gnuplot-x"
TERMUX_PKG_REPLACES="gnuplot-x"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
--disable-wxwidgets
--without-lua
--without-qt
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-wxwidgets
--with-x
--without-lua
--with-bitmap-terminals
--without-latex
--without-qt
ac_cv_search_iconv_open=-liconv
"

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR/configure" \
		${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	make -C docs/ gnuplot.gih
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/gnuplot/${TERMUX_PKG_VERSION:0:3}/

	cp $TERMUX_PKG_HOSTBUILD_DIR/docs/gnuplot.gih \
		$TERMUX_PREFIX/share/gnuplot/${TERMUX_PKG_VERSION:0:3}/gnuplot.gih
}
