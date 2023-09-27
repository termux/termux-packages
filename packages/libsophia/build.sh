TERMUX_PKG_HOMEPAGE=http://sophia.systems/
TERMUX_PKG_DESCRIPTION="Advanced transactional MVCC key-value/row storage library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2
TERMUX_PKG_SRCURL=git+https://github.com/pmwkaa/sophia
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib libsophia.a
	install -Dm600 -t $TERMUX_PREFIX/lib libsophia.so.2.2.0
	ln -sfT libsophia.so.2.2.0 $TERMUX_PREFIX/lib/libsophia.so.2.2
	ln -sfT libsophia.so.2.2.0 $TERMUX_PREFIX/lib/libsophia.so
}
