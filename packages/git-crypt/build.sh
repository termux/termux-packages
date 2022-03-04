TERMUX_PKG_HOMEPAGE=https://www.agwa.name/projects/git-crypt/
TERMUX_PKG_DESCRIPTION="Enables transparent encryption and decryption of files for a git repository"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@jottr"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/AGWA/git-crypt/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=777c0c7aadbbc758b69aff1339ca61697011ef7b92f1d1ee9518a8ee7702bb78
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
