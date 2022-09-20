TERMUX_PKG_HOMEPAGE="http://git.linux-nfs.org/?p=steved/libtirpc.git"
TERMUX_PKG_DESCRIPTION="Transport Independent RPC library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/libtirpc/libtirpc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6474e98851d9f6f33871957ddee9714fdcd9d8a5ee9abb5a98d63ea2e60e12f3
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gssapi"

termux_step_post_get_source() {
	sed -e "s|@RELEASE_VERSION@|${TERMUX_PKG_VERSION##*:}|" \
		$TERMUX_PKG_BUILDER_DIR/release-version.diff \
		| patch --silent -p1
}

termux_step_pre_configure() {
	aclocal
	automake
	autoconf
}
