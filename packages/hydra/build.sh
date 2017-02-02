TERMUX_PKG_HOMEPAGE=https://github.com/vanhauser-thc/thc-hydra
TERMUX_PKG_DESCRIPTION="Network logon cracker supporting different services"
TERMUX_PKG_VERSION=8.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vanhauser-thc/thc-hydra/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_CHECKTYPE=SHA256
TERMUX_PKG_CHECKSUM=b478157618e602e0a8adc412efacc1c2a5d95a8f5bfb30579fbf5997469cd8b4
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
