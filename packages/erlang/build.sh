TERMUX_PKG_HOMEPAGE="https://www.erlang.org/"
TERMUX_PKG_DESCRIPTION="General-purpose concurrent functional programming language developed by Ericsson"
TERMUX_PKG_VERSION="19.3"
TERMUX_PKG_DEPENDS="openssl, ncurses, libutil"
TERMUX_PKG_SRCURL="http://erlang.org/download/otp_src_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fe4a00651db39b8542b04530a48d24b2f2e7e0b77cbe93d728c9f05325bdfe83
TERMUX_PKG_FOLDERNAME="otp_src_$TERMUX_PKG_VERSION"
TERMUX_PKG_HOSTBUILD="yes"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-javac --with-ssl=${TERMUX_PREFIX} --with-termcap"
TERMUX_PKG_EXTRA_MAKE_ARGS="noboot"

termux_step_post_extract_package() {
	# We need a host build every time:
	rm -Rf "$TERMUX_PKG_HOSTBUILD_DIR"
}

termux_step_host_build () {
	cd $TERMUX_PKG_SRCDIR
	./configure --enable-bootstrap-only
	make -j "$TERMUX_MAKE_PROCESSES"
}

termux_step_pre_configure () {
	# liblog is needed for syslog usage:
	LDFLAGS+=" -llog"
	# Put binaries built in termux_step_host_build at start of PATH:
	cp bin/*/* $TERMUX_PKG_SRCDIR/bootstrap/bin
	export PATH="$TERMUX_PKG_SRCDIR/bootstrap/bin:$PATH"
}
