TERMUX_PKG_HOMEPAGE=http://picolisp.com
TERMUX_PKG_DESCRIPTION="Lisp interpreter and application server framework"
TERMUX_PKG_VERSION=3.1.11
TERMUX_PKG_SRCURL=http://software-lab.de/picoLisp-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_FOLDERNAME=picoLisp
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	CFLAGS+=" -c $LDFLAGS $CPPFLAGS"
}

termux_step_make_install () {
	cp $TERMUX_PKG_SRCDIR/../man/man1/{pil,picolisp}.1 $TERMUX_PREFIX/share/man/man1/

	rm -Rf $TERMUX_PREFIX/lib/picolisp
	mkdir -p $TERMUX_PREFIX/lib/picolisp

	cp -Rf $TERMUX_PKG_SRCDIR/../* $TERMUX_PREFIX/lib/picolisp/
	rm -Rf $TERMUX_PREFIX/lib/picolisp/{src,src64,man,java,ersatz}

	# Replace first line "#!/usr/bin/picolisp /usr/lib/picolisp/lib.l":
	sed -i "1 s|^.*$|#!$TERMUX_PREFIX/bin/picolisp $TERMUX_PREFIX/lib/picolisp/lib.l|g" $TERMUX_PREFIX/lib/picolisp/bin/pil

	( cd $TERMUX_PREFIX/bin && ln -f -s ../lib/picolisp/bin/picolisp picolisp && ln -f -s ../lib/picolisp/bin/pil pil )
}
