TERMUX_PKG_HOMEPAGE=https://racket-lang.org
TERMUX_PKG_DESCRIPTION="Full-spectrum programming language going beyond Lisp and Scheme"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.12"
TERMUX_PKG_SRCURL=https://www.cs.utah.edu/plt/installers/${TERMUX_PKG_VERSION}/racket-minimal-${TERMUX_PKG_VERSION}-src-builtpkgs.tgz
TERMUX_PKG_SHA256=af5436cffc1f28ea943750c411c44687d4ff5028aca5cfca84598c426830ea7c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libffi, libiconv"
TERMUX_PKG_NO_DEVELSPLIT=true
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
--enable-bc
--enable-bconly
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-bc
--enable-bconly
--enable-racket=$TERMUX_PKG_HOSTBUILD_DIR/bc/racketcgc
--enable-libs
--disable-shared
--disable-gracket
--enable-libffi"

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR"/src/configure \
		$TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS
	make -j "$TERMUX_MAKE_PROCESSES"
}

termux_step_pre_configure() {
	CPPFLAGS+=" -I$TERMUX_PKG_SRCDIR/src/bc/include -I$TERMUX_PKG_BUILDDIR/bc"
	LDFLAGS+=" -liconv -llog"
	export TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/src"
}
