TERMUX_PKG_HOMEPAGE=https://www.libsdl.org
TERMUX_PKG_DESCRIPTION="A library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=ca3acd25348edc9b6e984fc1712fd4d365931dc1
_COMMIT_DATE=20221201
TERMUX_PKG_VERSION=1.2.15-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/SDL-1.2.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="libiconv, libx11, libxext, libxrandr, libxrender, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="glu, mesa"
TERMUX_PKG_RECOMMENDS="mesa"
TERMUX_PKG_CONFLICTS="libsdl"
TERMUX_PKG_REPLACES="libsdl"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-assembly
--disable-nasm
--disable-pth
--enable-video-opengl
"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi
}
