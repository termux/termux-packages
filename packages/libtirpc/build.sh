TERMUX_PKG_HOMEPAGE="http://git.linux-nfs.org/?p=steved/libtirpc.git"
TERMUX_PKG_DESCRIPTION="Transport Independent RPC library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.8"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/libtirpc/libtirpc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8839959bfcc7a0f4c609d8e4f53f1c67ae33de23775ec35beb39ff15adf11920
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gssapi
--enable-rpcdb
"

termux_step_post_get_source() {
	sed -i "s/AC_INIT(libtirpc, [^)]*)/AC_INIT(libtirpc, ${TERMUX_PKG_VERSION##*:})/" configure.ac
}

termux_step_pre_configure() {
	# Avoid build errors such as: version script assignment of 'TIRPC_0.3.0' to symbol '_svcauth_gss' failed: symbol not defined
	LDFLAGS+=" -Wl,-undefined-version"

	autoreconf -fiv
}
