TERMUX_PKG_HOMEPAGE=https://practical-scheme.net/gauche/
TERMUX_PKG_DESCRIPTION="An R7RS Scheme implementation developed to be a handy script interpreter"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.15"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/shirok/Gauche/releases/download/release${TERMUX_PKG_VERSION//./_}/Gauche-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=3643e27bc7c8822cfd6fb2892db185f658e8e364938bc2ccfcedb239e35af783
TERMUX_PKG_AUTO_UPDATE=false
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
	make -j $TERMUX_PKG_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix

	cp $TERMUX_PKG_BUILDER_DIR/fake-ndbm-makedb.c "$TERMUX_PKG_SRCDIR"/ext/dbm/

	export BUILD_GOSH=$_PREFIX_FOR_BUILD/bin/gosh
	export PATH=$PATH:$_PREFIX_FOR_BUILD/bin

	autoreconf -fi
}
