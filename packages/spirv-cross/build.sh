TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/SPIRV-Cross
TERMUX_PKG_DESCRIPTION="Practical tool and library for performing reflection on SPIR-V"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="1.1.5"
# There are some possible important changes between upstream main and MoltenVK-1.1.5 tag.
# Therefore, package source must be cloned from Git.
TERMUX_PKG_GIT_BRANCH="main"
TERMUX_PKG_SRCURL="git+https://github.com/KhronosGroup/SPIRV-Cross"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
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
