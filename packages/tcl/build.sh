TERMUX_PKG_HOMEPAGE=https://www.tcl.tk/
TERMUX_PKG_DESCRIPTION="Powerful but easy to learn dynamic programming language"
TERMUX_PKG_DEPENDS="libsqlite"
_MAJOR_VERSION=8.6
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.5
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/tcl/Tcl/${TERMUX_PKG_VERSION}/tcl${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_FOLDERNAME=tcl$TERMUX_PKG_VERSION
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="tcl_cv_strtod_buggy=ok tcl_cv_strstr_unbroken=ok"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_strtod=yes tcl_cv_strtod_unbroken=ok"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_strtoul=yes tcl_cv_strtoul_unbroken=ok"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_memcmp=yes ac_cv_func_memcmp_working=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --mandir=$TERMUX_PREFIX/share/man --enable-man-symlinks"


termux_step_pre_configure () {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/unix
}

termux_step_post_make_install () {
	cd $TERMUX_PREFIX/bin
	ln -f -s tclsh$_MAJOR_VERSION tclsh
}
