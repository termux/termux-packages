TERMUX_PKG_HOMEPAGE=https://github.com/bettio/AtomVM
TERMUX_PKG_DESCRIPTION="The minimal Erlang VM implementation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=82624fbf68ad8a0c8815456adbd33de98e4901ea
TERMUX_PKG_VERSION=0.git${_COMMIT:0:8}
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/bettio/AtomVM/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=b141812be3fe157766464b8fcedc13f40b36bc9346b3e039ac736c5d30359729
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_cmake
	cmake "$TERMUX_PKG_SRCDIR"
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_post_configure() {
	# We need the "PackBEAM" compiled for host.
	export PATH=$PATH:$TERMUX_PKG_HOSTBUILD_DIR/tools/packbeam
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/src/AtomVM \
		"$TERMUX_PREFIX"/bin/AtomVM
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/tools/packbeam/PackBEAM \
		"$TERMUX_PREFIX"/bin/PackBEAM
}
