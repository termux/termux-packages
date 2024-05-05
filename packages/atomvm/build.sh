TERMUX_PKG_HOMEPAGE=https://github.com/bettio/AtomVM
TERMUX_PKG_DESCRIPTION="The minimal Erlang VM implementation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.6.1"
TERMUX_PKG_SRCURL=https://github.com/atomvm/AtomVM/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=fdc9ead6de43b7896172f9d1902badb6c7c0a2f84c647a3f40f0846ba3a691bb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DAVM_BUILD_RUNTIME_ONLY=ON
"

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
