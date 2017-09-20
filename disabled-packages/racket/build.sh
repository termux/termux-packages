TERMUX_PKG_HOMEPAGE=https://racket-lang.org
TERMUX_PKG_DESCRIPTION="Full-spectrum programming language going beyond Lisp and Scheme"
TERMUX_PKG_VERSION=6.7
TERMUX_PKG_SRCURL=https://mirror.racket-lang.org/installers/${TERMUX_PKG_VERSION}/racket-minimal-${TERMUX_PKG_VERSION}-src-builtpkgs.tgz
TERMUX_PKG_SHA256=4203d9b51a0de7ea549db966cfa49a736f8605ab51e2f198cbdb9cfaf428b0f3
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="libffi, libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-racket=$TERMUX_PKG_HOSTBUILD_DIR/racket/racketcgc"
# Building racket hits the 'the wrong gcc-problem' detailed at
# http://www.metastatic.org/text/libtool.html
# due to --tag=CC being used. To avoid that a cross libtool
# built in termux_step_post_extract_package() below and used
# due to this configure argument:
_CROSS_LIBTOOL_DIR=$TERMUX_PKG_CACHEDIR/libtool-cross-2.4.6-${TERMUX_HOST_PLATFORM}
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-lt=$_CROSS_LIBTOOL_DIR/bin/${TERMUX_HOST_PLATFORM}-libtool"

termux_step_post_extract_package () {
	if [ ! -d $_CROSS_LIBTOOL_DIR ]; then
		LIBTOOL_TARFILE=$TERMUX_PKG_CACHEDIR/libtool-2.4.6.tar.gz
		if [ ! -f $LIBTOOL_TARFILE ]; then
			curl -L -o $LIBTOOL_TARFILE http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
		fi
		cd $TERMUX_PKG_CACHEDIR
		tar xf $LIBTOOL_TARFILE
		cd libtool-2.4.6
		./configure --prefix=$_CROSS_LIBTOOL_DIR --host=$TERMUX_HOST_PLATFORM --program-prefix=${TERMUX_HOST_PLATFORM}-
		make install
	fi
}

termux_step_host_build () {
	$TERMUX_PKG_SRCDIR/src/configure ${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_pre_configure () {
	# Due to use of syslog.
	LDFLAGS+=" -llog"

	# Do this after patching:
	export TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
}
