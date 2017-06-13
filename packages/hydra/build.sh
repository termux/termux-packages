TERMUX_PKG_HOMEPAGE=https://github.com/vanhauser-thc/thc-hydra
TERMUX_PKG_DESCRIPTION="Network logon cracker supporting different services"
TERMUX_PKG_VERSION=8.5
TERMUX_PKG_SRCURL=https://github.com/vanhauser-thc/thc-hydra/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=69b69d16ce9499f3a941836b4d8a1c8a3ff9b905c921cc8c588a3af7f65a3b4b
TERMUX_PKG_FOLDERNAME=thc-hydra-$TERMUX_PKG_VERSION
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
