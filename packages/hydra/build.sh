TERMUX_PKG_HOMEPAGE=https://github.com/vanhauser-thc/thc-hydra
TERMUX_PKG_DESCRIPTION="Network logon cracker supporting different services"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.1
TERMUX_PKG_SRCURL=https://github.com/vanhauser-thc/thc-hydra/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ce08a5148c0ae5ff4b0a4af2f7f15c5946bc939a57eae1bbb6dda19f34410273
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl, pcre, libssh"

termux_step_configure() {
	# Skip the ./configure file (which does not support cross compilation)
	# and configure the build manually.
	CFLAGS+=" -Dindex=strchr -Drindex=strrchr -DLIBOPENSSL -DNO_RINDEX -DHAVE_MATH_H -DHAVE_PCRE -DLIBSSH"
	export MANDIR=/share/man/man1
	export XLIBS="-lcrypto -lssl -lpcre -lssh"
	cat Makefile.am | sed 's/^install:.*/install: all/'  >> Makefile
}
