TERMUX_PKG_HOMEPAGE=https://www.agwa.name/projects/git-crypt/
TERMUX_PKG_DESCRIPTION="Enables transparent encryption and decryption of files for a git repository"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@jottr"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/AGWA/git-crypt/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2210a89588169ae9a54988c7fdd9717333f0c6053ff704d335631a387bd3bcff
TERMUX_PKG_DEPENDS="git, libc++, openssl-1.1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DCMAKE_BUILD_TYPE=Release -Dbuild_parse=yes -Dbuild_xmlparser=yes"
TERMUX_PKG_EXTRA_MAKE_ARGS="ENABLE_MAN=yes"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CXXFLAGS"
	LDFLAGS="-L$TERMUX_PREFIX/lib/openssl-1.1 -Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1 $LDFLAGS"
}
