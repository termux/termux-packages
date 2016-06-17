TERMUX_PKG_HOMEPAGE=http://picolisp.com
TERMUX_PKG_DESCRIPTION="Lisp interpreter and application server framework"
TERMUX_PKG_DEPENDS="libcrypt, openssl"
_PICOLISP_YEAR=16
_PICOLISP_MONTH=6
_PICOLISP_DAY=4
TERMUX_PKG_VERSION=${_PICOLISP_YEAR}.${_PICOLISP_MONTH}.${_PICOLISP_DAY}
TERMUX_PKG_SRCURL=http://software-lab.de/picoLisp.tgz
TERMUX_PKG_NO_SRC_CACHE=yes
TERMUX_PKG_FOLDERNAME=picoLisp
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Validate that we have the right version:
	grep -q "$_PICOLISP_YEAR $_PICOLISP_MONTH $_PICOLISP_DAY" src64/version.l

	if [ $TERMUX_ARCH_BITS = 64 ]; then
		cd $TERMUX_PKG_SRCDIR
		if [ $TERMUX_ARCH = "aarch64" ]; then
			export TERMUX_PKG_EXTRA_MAKE_ARGS=arm64.linux
			termux_download http://software-lab.de/arm64.linux.tgz $TERMUX_PKG_TMPDIR/arm64.linux.tgz
			tar xf $TERMUX_PKG_TMPDIR/arm64.linux.tgz
		elif [ $TERMUX_ARCH = "x86_64" ]; then
			export TERMUX_PKG_EXTRA_MAKE_ARGS=x86-64.linux
			termux_download http://software-lab.de/x86-64.linux.tgz $TERMUX_PKG_TMPDIR/x86-64.linux.tgz
			tar xf $TERMUX_PKG_TMPDIR/x86-64.linux.tgz
		else
			echo "Error: Unsupported arch: $TERMUX_ARCH"
			exit 1
		fi
		TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src64
	else
		TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
	fi
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	ORIG_CFLAGS="$CFLAGS"
	CFLAGS+=" -c $LDFLAGS $CPPFLAGS"
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR/

	if [ $TERMUX_ARCH_BITS = "64" ]; then
		$AS -pie -o ../bin/picolisp -rdynamic ${TERMUX_PKG_EXTRA_MAKE_ARGS}.base.s -lc -lm -ldl
		chmod +x ../bin/picolisp
		$AS -pie -o ../lib/ext -shared -export-dynamic ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ext.s
		$AS -pie -o ../lib/ht -shared -export-dynamic ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ht.s
	fi

	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/../man/man1/{pil,picolisp}.1 $TERMUX_PREFIX/share/man/man1/

	rm -Rf $TERMUX_PREFIX/lib/picolisp
	mkdir -p $TERMUX_PREFIX/lib/picolisp

	cp -Rf $TERMUX_PKG_SRCDIR/../* $TERMUX_PREFIX/lib/picolisp/
	rm -Rf $TERMUX_PREFIX/lib/picolisp/{src,src64,man,java,ersatz}

	# Replace first line "#!/usr/bin/picolisp /usr/lib/picolisp/lib.l":
	sed -i "1 s|^.*$|#!$TERMUX_PREFIX/bin/picolisp $TERMUX_PREFIX/lib/picolisp/lib.l|g" $TERMUX_PREFIX/lib/picolisp/bin/pil

	( cd $TERMUX_PREFIX/bin && ln -f -s ../lib/picolisp/bin/picolisp picolisp && ln -f -s ../lib/picolisp/bin/pil pil )

	# Bundled tools:
	$CC $ORIG_CFLAGS $CPPFLAGS $LDFLAGS -o $TERMUX_PREFIX/lib/picolisp/bin/ssl ../src/ssl.c -lssl -lcrypto
	$CC $ORIG_CFLAGS $CPPFLAGS $LDFLAGS -o $TERMUX_PREFIX/lib/picolisp/bin/httpGate ../src/httpGate.c -lssl -lcrypto

	# Man pages:
	cp $TERMUX_PKG_SRCDIR/../man/man1/{pil,picolisp}.1 $TERMUX_PREFIX/share/man/man1/
}
