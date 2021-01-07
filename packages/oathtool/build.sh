TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/oath-toolkit/
TERMUX_PKG_DESCRIPTION="One-time password components"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.5
TERMUX_PKG_SRCURL=http://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d207120c7e7fdd540142d04ca06d83fb3277c8f2fb794a74535d04b2aa0ec219
TERMUX_PKG_DEPENDS="xmlsec, zlib"
TERMUX_PKG_BREAKS="oathtool-dev"
TERMUX_PKG_REPLACES="oathtool-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pam"

termux_step_pre_configure() {
	if $TERMUX_DEBUG; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.termux-build/oathtool/src/liboath/usersfile.c:482:46: error: 'umask' called with invalid mode
		#       old_umask = umask (~(S_IRUSR | S_IWUSR));
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
