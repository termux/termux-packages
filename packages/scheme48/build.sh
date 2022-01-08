TERMUX_PKG_HOMEPAGE=https://www.s48.org/
TERMUX_PKG_DESCRIPTION="An implementation of the Scheme programming language"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.2
TERMUX_PKG_SRCURL=https://www.s48.org/${TERMUX_PKG_VERSION}/scheme48-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_bits_per_byte=8
ac_cv_header_pthread_h=no
"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	$TERMUX_PKG_SRCDIR/configure \
		CFLAGS=-m${TERMUX_ARCH_BITS} LDFLAGS=-m${TERMUX_ARCH_BITS}
	make -j $TERMUX_MAKE_PROCESSES scheme48vm
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_sizeof_void_p=$(( $TERMUX_ARCH_BITS / 8 ))"
}

termux_step_post_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
}
