TERMUX_PKG_HOMEPAGE=https://premake.github.io/
TERMUX_PKG_DESCRIPTION="Build script generator"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0.0-beta1
TERMUX_PKG_SRCURL=https://github.com/premake/premake-core/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=97fa4cef9fb6459c39da4e70756c0e13ae7b090fffe9442306c768b8b62e1589
# TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl"


termux_step_pre_configure() {
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR/build/gmake.unix
}
