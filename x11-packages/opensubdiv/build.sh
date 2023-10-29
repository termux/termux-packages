TERMUX_PKG_HOMEPAGE=https://graphics.pixar.com/opensubdiv/docs/intro.html
TERMUX_PKG_DESCRIPTION="A set of open source libraries that implement high performance subdivision surface (subdiv) evaluation"
# License: Modified Apache 2.0 License
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, NOTICE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.6.0"
TERMUX_PKG_SRCURL=https://github.com/PixarAnimationStudios/OpenSubdiv/archive/refs/tags/v${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=bebfd61ab6657a4f4ff27845fb66a167d00395783bfbd253254d87447ed1d879
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+_\d+_\d+"
TERMUX_PKG_DEPENDS="libc++, libtbb, opengl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DNO_EXAMPLES=ON
-DNO_TUTORIALS=ON
-DNO_PTEX=ON
-DNO_DOC=ON
-DNO_CUDA=ON
-DNO_OPENCL=ON
-DNO_TESTS=ON
-DNO_GLFW=ON
"

termux_pkg_auto_update() {
	# Get latest release tag:
	local tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" newest-tag)"
	if grep -qP "^${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a release ($tag)"
	fi
}
