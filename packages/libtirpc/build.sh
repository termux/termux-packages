TERMUX_PKG_HOMEPAGE="http://git.linux-nfs.org/?p=steved/libtirpc.git"
TERMUX_PKG_DESCRIPTION="Transport Independent RPC library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.7"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/libtirpc/libtirpc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b47d3ac19d3549e54a05d0019a6c400674da716123858cfdb6d3bdd70a66c702
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gssapi"

termux_step_post_get_source() {
	sed -i "s/AC_INIT(libtirpc, [^)]*)/AC_INIT(libtirpc, ${TERMUX_PKG_VERSION##*:})/" configure.ac
}

termux_step_pre_configure() {
	# Avoid build errors such as: version script assignment of 'TIRPC_0.3.0' to symbol '_svcauth_gss' failed: symbol not defined
	LDFLAGS+=" -Wl,-undefined-version"

	autoreconf -fiv
}
