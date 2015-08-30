TERMUX_PKG_HOMEPAGE=https://www.tcl.tk/
TERMUX_PKG_DESCRIPTION="Powerful but easy to learn dynamic programming language"
_MAJOR_VERSION=8.6
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/tcl/Tcl/${TERMUX_PKG_VERSION}/tcl${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_FOLDERNAME=tcl$TERMUX_PKG_VERSION
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="tcl_cv_strtod_buggy=ok --mandir=$TERMUX_PREFIX/share/man"

termux_step_pre_configure () {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/unix
}

termux_step_post_make_install () {
	cd $TERMUX_PREFIX/bin
	ln -f -s tclsh$_MAJOR_VERSION tclsh
}
