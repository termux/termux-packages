TERMUX_PKG_HOMEPAGE=https://github.com/vanhauser-thc/thc-hydra
TERMUX_PKG_DESCRIPTION="Network logon cracker supporting different services"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=8.9.1
TERMUX_PKG_SHA256=7c615622d9d22a65b007e545f2d85da06c422a042f720bd6c5578a1844dec40e
TERMUX_PKG_SRCURL=https://github.com/vanhauser-thc/thc-hydra/archive/v$TERMUX_PKG_VERSION.tar.gz
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
