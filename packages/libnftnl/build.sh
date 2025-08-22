TERMUX_PKG_HOMEPAGE=https://www.netfilter.org/projects/libnftnl/
TERMUX_PKG_DESCRIPTION="Netfilter library providing interface to the nf_tables subsystem"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL=https://netfilter.org/projects/libnftnl/files/libnftnl-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=0f4be47a8bb8b77a350ee58cbd4b5fae6260ad486a527706ab15cfe1dd55a3c4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libmnl"
TERMUX_PKG_BREAKS="libnftnl-dev"
TERMUX_PKG_REPLACES="libnftnl-dev"

termux_step_pre_configure() {
	# Avoid the below errors:
	# error: version script assignment of 'LIBNFTNL_11' to symbol 'nftnl_chain_parse' failed: symbol not defined
	# error: version script assignment of 'LIBNFTNL_11' to symbol 'nftnl_chain_parse_file' failed: symbol not defined
	# error: version script assignment of 'LIBNFTNL_11' to symbol 'nftnl_set_elems_foreach' failed: symbol not defined
	# See https://bugs.gentoo.org/914710
	LDFLAGS+=" -Wl,-undefined-version"
}
