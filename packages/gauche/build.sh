TERMUX_PKG_HOMEPAGE=https://practical-scheme.net/gauche/
TERMUX_PKG_DESCRIPTION="An R7RS Scheme implementation developed to be a handy script interpreter"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.12
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/shirok/Gauche/releases/download/release${TERMUX_PKG_VERSION//./_}/Gauche-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617
TERMUX_PKG_DEPENDS="gdbm, libcrypt, libiconv, mbedtls, zlib"
TERMUX_PKG_BUILD_DEPENDS="libatomic-ops"
TERMUX_PKG_RECOMMENDS="binutils-is-llvm | binutils, ca-certificates"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-slib=$TERMUX_PREFIX/share/slib
"
# As of 0.9.10 some code hangs with threads enabled, e.g.
# ```
# (use rfc.uri)
# (uri-decode-string "")
# ```
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-threads=none"

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD

	find "$TERMUX_PKG_SRCDIR" -mindepth 1 -maxdepth 1 ! -name build_gosh -exec cp -a \{\} ./ \;
	./configure --prefix=$_PREFIX_FOR_BUILD
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix

	cp $TERMUX_PKG_BUILDER_DIR/fake-ndbm-makedb.c "$TERMUX_PKG_SRCDIR"/ext/dbm/

	export BUILD_GOSH=$_PREFIX_FOR_BUILD/bin/gosh
	export PATH=$PATH:$_PREFIX_FOR_BUILD/bin

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi

	autoreconf -fi
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
}
