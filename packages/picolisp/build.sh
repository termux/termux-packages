TERMUX_PKG_HOMEPAGE=https://picolisp.com/wiki/?home
TERMUX_PKG_DESCRIPTION="Lisp interpreter and application server framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.12
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/universe/p/picolisp/picolisp_$TERMUX_PKG_VERSION.orig.tar.gz
TERMUX_PKG_SHA256=a06838236b7f5b52c5d587d32d31627f73cdb9775cc02a80f2cdaedd12888c7d
TERMUX_PKG_DEPENDS="libcrypt, libffi, openssl, readline"
TERMUX_PKG_BUILD_IN_SRC=true
# For 32-bit archs we nees to build minipicolisp
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR/src
	opt-12 -O3 --mtriple=$CCTERMUX_HOST_PLATFORM -o base.bc base.ll
	$CC -O3 -w -c -D_OS="\"Android\"" -D_CPU="\"$TERMUX_ARCH\"" `$PKGCONFIG --cflags libffi` -emit-llvm lib.c
	llvm-link-12 -o picolisp.bc base.bc lib.bc
	mkdir -p ../bin ../lib
	llc-12 --mtriple=$CCTERMUX_HOST_PLATFORM picolisp.bc -relocation-model=pic -o picolisp.s
	$CC $CFLAGS $LDFLAGS picolisp.s -o ../bin/picolisp -rdynamic -lutil -lm -ldl -lreadline -lffi
	$STRIP ../bin/picolisp

	opt-12 -O3 --mtriple=$CCTERMUX_HOST_PLATFORM -o ext.bc ext.ll
	llc-12 --mtriple=$CCTERMUX_HOST_PLATFORM ext.bc -relocation-model=pic -o ext.s
	$CC $CFLAGS $LDFLAGS ext.s -o ../lib/ext.so -shared
	$STRIP ../lib/ext.so

	opt-12 -O3 --mtriple=$CCTERMUX_HOST_PLATFORM -o ht.bc ht.ll
	llc-12 --mtriple=$CCTERMUX_HOST_PLATFORM ht.bc -relocation-model=pic -o ht.s
	$CC $CFLAGS $LDFLAGS ht.s -o ../lib/ht.so -shared
	$STRIP ../lib/ht.so

	$CC -O3 -w $CFLAGS -I$TERMUX_PREFIX/include -L$TERMUX_PREFIX/lib $LDFLAGS -o ../bin/balance balance.c
	$CC -O3 -w $CFLAGS -I$TERMUX_PREFIX/include -L$TERMUX_PREFIX/lib $LDFLAGS -o ../bin/ssl ssl.c -lssl -lcrypto
	$CC -O3 -w $CFLAGS -I$TERMUX_PREFIX/include -L$TERMUX_PREFIX/lib $LDFLAGS -o ../bin/httpGate httpGate.c -lssl -lcrypto

	$CC -O3 -w -D_OS="\"Android\"" -D_CPU="\"$TERMUX_ARCH\"" $CFLAGS -I$TERMUX_PREFIX/include -L$TERMUX_PREFIX/lib $LDFLAGS sysdefs.c -o ../bin/sysdefs-gen

	$STRIP ../bin/balance
	$STRIP ../bin/ssl
	$STRIP ../bin/httpGate
	$STRIP ../bin/sysdefs-gen
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/src
	install ../bin/{picolisp,pil} -t $TERMUX_PREFIX/bin

	install -d -m755 $TERMUX_PREFIX/lib/picolisp/bin
	install ../bin/{balance,httpGate,psh,ssl,sysdefs-gen,vip,watchdog} -t $TERMUX_PREFIX/lib/picolisp
	
	install ../{ext.l,lib.css,lib.l} -t $TERMUX_PREFIX/lib/picolisp
	install -d -m755 $TERMUX_PREFIX/lib/picolisp/lib

	cp ../lib $TERMUX_PREFIX/lib/picolisp -r
	cp ../loc $TERMUX_PREFIX/lib/picolisp -r
	cp ../src $TERMUX_PREFIX/lib/picolisp -r
	cp ../test $TERMUX_PREFIX/lib/picolisp -r
	cp ../doc $TERMUX_PREFIX/lib/picolisp -r
	cp ../img $TERMUX_PREFIX/lib/picolisp -r

	install -d -m755 $TERMUX_PREFIX/share/man/man1
	install ../man/man1/*.1 -t $TERMUX_PREFIX/share/man/man1
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	$TERMUX_PREFIX/lib/picolisp/sysdefs-gen > $TERMUX_PREFIX/lib/picolisp/sysdefs
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	rm -f $TERMUX_PREFIX/lib/picolisp/sysdefs
	EOF
}
