TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/SPIRV-Cross
TERMUX_PKG_DESCRIPTION="Practical tool and library for performing reflection on SPIR-V"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="1.4.363.0"
TERMUX_PKG_SRCURL="https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/vulkan-sdk-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f708982e88b763ef5b0394ed468fc2c3628f68cdab89f2e7a946cd628c04e721
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSPIRV_CROSS_SHARED=ON
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
"

termux_step_post_make_install() {
	# Make a symlink for the main shared library so apps like PrismLauncher
	# can find the library.
	ln -sfrT "$TERMUX__PREFIX__LIB_DIR/libspirv-cross-c-shared.so" \
		"$TERMUX__PREFIX__LIB_DIR/libspirv-cross.so"
}
