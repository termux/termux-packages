TERMUX_PKG_HOMEPAGE=http://premake.github.io/
TERMUX_PKG_DESCRIPTION="Build script generator"
TERMUX_PKG_VERSION=4.4-beta5
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/premake/Premake/4.4/premake-${TERMUX_PKG_VERSION}-src.zip
# TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl"


termux_step_pre_configure() {
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR/build/gmake.unix
}
