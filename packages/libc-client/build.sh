TERMUX_PKG_HOMEPAGE=https://www.washington.edu/imap/ # Gone.
TERMUX_PKG_DESCRIPTION="UW IMAP c-client library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2007f
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.mirrorservice.org/sites/ftp.cac.washington.edu/imap/imap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=53e15a2b5c1bc80161d42e9f69792a3fa18332b7b771910131004eb520004a28
TERMUX_PKG_DEPENDS="libcrypt, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -fPIC $CPPFLAGS -DFNDELAY=O_NONBLOCK -DL_SET=SEEK_SET"
	LDFLAGS+=" -lcrypt -lssl -lcrypto"
}

termux_step_configure() {
	:
}

termux_step_make() {
	make -e slx

	mv c-client/{,lib}c-client.a
	$CC -Wl,--whole-archive c-client/libc-client.a -Wl,--no-whole-archive -shared -o c-client/libc-client.so -Wl,-soname=libc-client.so $LDFLAGS
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib c-client/libc-client.{a,so}
	install -Dm600 -t $TERMUX_PREFIX/include/c-client c-client/linkage.[ch] src/c-client/*.h src/osdep/unix/*.h
	cp -a c-client/osdep.h $TERMUX_PREFIX/include/c-client/
}
