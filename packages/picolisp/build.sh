TERMUX_PKG_HOMEPAGE="https://picolisp.com/wiki/?home"
TERMUX_PKG_DESCRIPTION="Lisp interpreter and application server framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.6"
TERMUX_PKG_SRCURL=https://software-lab.de/picoLisp-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=912245a1a47714c6bf7e456f119272c0dd1faf263b55cec1cc23da3b5b0a0222
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcrypt, libffi, openssl, readline"
TERMUX_PKG_BUILD_IN_SRC=true
# For 32-bit archs we nees to build minipicolisp
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	sed -i "s|/usr/lib/picolisp/lib.l|${TERMUX_PREFIX}/lib/picolisp/lib.l|" $TERMUX_PKG_SRCDIR/bin/pil
	sed -i "s|/usr/lib/picolisp/lib.l|${TERMUX_PREFIX}/lib/picolisp/lib.l|" $TERMUX_PKG_SRCDIR/bin/vip
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

	install -Dm755 -t $TERMUX_PREFIX/bin ../bin/{picolisp,pil}
	install -Dm755 -t $TERMUX_PREFIX/lib/picolisp/bin ../bin/{balance,httpGate,psh,ssl,sysdefs-gen,vip,watchdog}
	install -Dm644 -t $TERMUX_PREFIX/lib/picolisp ../{ext.l,lib.css,lib.l}
	install -Dm644 -t $TERMUX_PREFIX/share/man/man1 ../man/man1/*.1

	install -d -m755 $TERMUX_PREFIX/lib/picolisp/lib
	cp -r ../lib $TERMUX_PREFIX/lib/picolisp
	cp -r ../loc $TERMUX_PREFIX/lib/picolisp
	cp -r ../src $TERMUX_PREFIX/lib/picolisp
	cp -r ../test $TERMUX_PREFIX/lib/picolisp
	cp -r ../doc $TERMUX_PREFIX/lib/picolisp
	cp -r ../img $TERMUX_PREFIX/lib/picolisp

	install -Dm644 ../lib/bash_completion $TERMUX_PREFIX/share/bash-completion/completions/pil
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	$TERMUX_PREFIX/lib/picolisp/bin/sysdefs-gen > $TERMUX_PREFIX/lib/picolisp/lib/sysdefs
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	rm -f $TERMUX_PREFIX/lib/picolisp/lib/sysdefs
	EOF
}
