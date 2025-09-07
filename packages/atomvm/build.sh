TERMUX_PKG_HOMEPAGE=https://github.com/bettio/AtomVM
TERMUX_PKG_DESCRIPTION="The minimal Erlang VM implementation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.6.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/atomvm/AtomVM/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=2a7de9b0ec201d992847d6ebbb444708ac07f210c9fa650d7f677c8ec20df074
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DAVM_BUILD_RUNTIME_ONLY=ON
"

termux_step_host_build() {
	termux_setup_cmake
	cmake "$TERMUX_PKG_SRCDIR" $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make -j $TERMUX_PKG_MAKE_PROCESSES
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
