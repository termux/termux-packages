TERMUX_PKG_HOMEPAGE=https://github.com/vanhauser-thc/thc-hydra
TERMUX_PKG_DESCRIPTION="Network logon cracker supporting different services"
TERMUX_PKG_VERSION=8.6
TERMUX_PKG_SHA256=05a87eb018507b24afca970081f067e64441460319fb75ca1e64c4a1f322b80b
TERMUX_PKG_SRCURL=https://github.com/vanhauser-thc/thc-hydra/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="openssl, pcre, libssh"

termux_step_configure() {
	# Skip the ./configure file (which does not support cross compilation)
	# and configure the build manually.
	CFLAGS+=" -Dindex=strchr -DLIBOPENSSL -DNO_RINDEX -DHAVE_MATH_H -DHAVE_PCRE -DLIBSSH"
	export MANDIR=/share/man/man1
	export XLIBS="-lcrypto -lssl -lpcre -lssh"
	cat Makefile.am | sed 's/^install:.*/install: all/'  >> Makefile
}
