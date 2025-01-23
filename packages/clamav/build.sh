TERMUX_PKG_HOMEPAGE=https://www.clamav.net/
TERMUX_PKG_DESCRIPTION="Anti-virus toolkit for Unix"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.2"
TERMUX_PKG_SRCURL=https://www.clamav.net/downloads/production/clamav-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8c92f8ade2a8f2c9d6688d1d63ee57f6caf965d74dce06d0971c6709c8e6c04c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="json-c, libandroid-support, libbz2, libc++, libcurl, libiconv, libxml2, ncurses, openssl, pcre2, zlib"
TERMUX_PKG_BREAKS="clamav-dev"
TERMUX_PKG_REPLACES="clamav-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DAPP_CONFIG_DIRECTORY=$TERMUX_PREFIX/etc/clamav
-DBYTECODE_RUNTIME=interpreter
-DENABLE_CLAMONACC=OFF
-DENABLE_MILTER=OFF
-DENABLE_TESTS=OFF
-Dtest_run_result=0
-Dtest_run_result__TRYRUN_OUTPUT=
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man5/clamav-milter.conf.5
share/man/man8/clamav-milter.8
share/man/man8/clamonacc.8
"
TERMUX_PKG_CONFFILES="
etc/clamav/clamd.conf
etc/clamav/freshclam.conf"

termux_step_pre_configure() {
	local _lib="$TERMUX_PKG_BUILDDIR/_syncfs/lib"
	rm -rf "${_lib}"
	mkdir -p "${_lib}"
	pushd "${_lib}"/..
	$CC $CFLAGS $CPPFLAGS "$TERMUX_PKG_BUILDER_DIR/syncfs.c" \
		-fvisibility=hidden -c -o ./syncfs.o
	$AR cru "${_lib}"/libsyncfs.a ./syncfs.o
	popd

	LDFLAGS+=" -L${_lib} -l:libsyncfs.a"

	termux_setup_rust
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRUST_COMPILER_TARGET=$CARGO_TARGET_NAME"
}

termux_step_post_make_install() {
	for conf in clamd.conf freshclam.conf; do
		sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
			"$TERMUX_PKG_BUILDER_DIR"/$conf.in \
			> "$TERMUX_PREFIX"/etc/clamav/$conf
	done
	unset conf
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/lib/clamav
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/log/clamav
}
