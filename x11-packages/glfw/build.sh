TERMUX_PKG_HOMEPAGE=https://www.glfw.org/
TERMUX_PKG_DESCRIPTION="An Open Source, multi-platform library for OpenGL, OpenGL ES and Vulkan application development"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=9a87635686c7fcb63ca63149c5b179b85a53a725
_COMMIT_DATE=20230303
TERMUX_PKG_VERSION=3.3.8-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://github.com/glfw/glfw
TERMUX_PKG_SHA256=54ff7b5753857681ad832110e3b0729eadb128289dd58ba0a9f5cf487dbaf901
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="opengl"
TERMUX_PKG_BUILD_DEPENDS="libxcursor, libxi, libxinerama, libxrandr, xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DGLFW_BUILD_EXAMPLES=OFF
-DGLFW_BUILD_TESTS=OFF
-DGLFW_BUILD_DOCS=OFF
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

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
