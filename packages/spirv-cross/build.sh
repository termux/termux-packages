TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/SPIRV-Cross
TERMUX_PKG_DESCRIPTION="Practical tool and library for performing reflection on SPIR-V"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="1.1.5"
TERMUX_PKG_SRCURL="https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/MoltenVK-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e11845d9a4ccb4666923a8b678935cf78acad2b4fc131aba779f5bcc6def5191
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DSPIRV_CROSS_SHARED=ON
"

termux_step_post_make_install() {
	# Make a symlink for the main shared library so apps like PrismLauncher
	# can find the library.
	ln -t "$TERMUX__PREFIX__LIB_DIR" \
		-sf libspirv-cross-c-shared.so libspirv-cross.so
}
