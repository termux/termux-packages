TERMUX_PKG_HOMEPAGE=https://github.com/sahlberg/libnfs
TERMUX_PKG_DESCRIPTION="NFS client library"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_SHA256=6eaeb85559bb3e378284688f06fc56b018d324a5fc69f3f5259d24593ad113cf
TERMUX_PKG_SRCURL=https://sites.google.com/site/libnfstarballs/li/libnfs-${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure() {
	CFLAGS+=" -Wno-tautological-compare"
	autoreconf -vif
}
