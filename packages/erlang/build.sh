TERMUX_PKG_HOMEPAGE="https://www.erlang.org/"
TERMUX_PKG_DESCRIPTION="General-purpose concurrent functional programming language developed by Ericsson"
TERMUX_PKG_VERSION="19.2"
TERMUX_PKG_DEPENDS="openssl, ncurses, libutil"
TERMUX_PKG_SRCURL="http://erlang.org/download/otp_src_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a016b3ef5dac1e532972617b2715ef187ecb616f7cd7ddcfe0f1d502f5d24870
TERMUX_PKG_FOLDERNAME="otp_src_$TERMUX_PKG_VERSION"
TERMUX_PKG_HOSTBUILD="yes"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-javac --with-ssl=${TERMUX_PREFIX} --with-termcap"
TERMUX_PKG_EXTRA_MAKE_ARGS="noboot"

termux_step_host_build () {
	cd $TERMUX_PKG_SRCDIR
	./configure --enable-bootstrap-only
	make -j "$TERMUX_MAKE_PROCESSES"
	cp "${TERMUX_PKG_SRCDIR}"/bin/*/* "$TERMUX_PKG_HOSTBUILD_DIR"
}

termux_step_pre_configure () {
	# liblog is needed for syslog usage:
	LDFLAGS+=" -llog"
	# Put binaries built in termux_step_host_build at start of PATH:
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
}
