TERMUX_PKG_HOMEPAGE=https://picolisp.com/wiki/?home
TERMUX_PKG_DESCRIPTION="Lisp interpreter and application server framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=22.9
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/p/picolisp/picolisp_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=2cf0ed9e176c9df76a2c5cffc87c48d838b7560fb678a16a45569521102da1e8
TERMUX_PKG_DEPENDS="libcrypt, libffi, openssl, readline"
TERMUX_PKG_BUILD_IN_SRC=true
# For 32-bit archs we nees to build minipicolisp
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR/src
	$CC -O3 -c -emit-llvm base.ll
	$CC -O3 -w -c -D_OS="\"Android\"" -D_CPU="\"$TERMUX_ARCH\"" `$PKGCONFIG --cflags libffi` -emit-llvm lib.c
	mkdir -p ../bin ../lib
	$CC $CFLAGS $LDFLAGS base.bc lib.bc -o ../bin/picolisp -rdynamic -lutil -lm -ldl -lreadline -lffi
	$STRIP ../bin/picolisp

	$CC -O3 -c -emit-llvm ext.ll
	$CC $CFLAGS $LDFLAGS ext.bc -o ../lib/ext.so -shared
	$STRIP ../lib/ext.so

	$CC -O3 -c -emit-llvm ht.ll
	$CC $CFLAGS $LDFLAGS ht.bc -o ../lib/ht.so -shared
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
	$TERMUX_PREFIX/lib/picolisp/sysdefs-gen > $TERMUX_PREFIX/lib/picolisp/lib/sysdefs
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	rm -f $TERMUX_PREFIX/lib/picolisp/lib/sysdefs
	EOF
}
