TERMUX_PKG_HOMEPAGE=https://github.com/ArtifexSoftware/pipcl
TERMUX_PKG_DESCRIPTION="Python packaging operations for use by python-mupdf and python-pymupdf"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="12"
TERMUX_PKG_SRCURL="https://github.com/ArtifexSoftware/pipcl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b0f5b04b6992fbd10d1517dcde9b4e12b20bafd42b32e3f180c73a08df2ea021
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, installer"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# should probably be updated with reverse dependencies python-mupdf and python-pymupdf
TERMUX_PKG_AUTO_UPDATE=false

termux_step_pre_configure() {
	patch="$TERMUX_PKG_BUILDER_DIR/termux.diff"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && sed \
		-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		-e "s%\@TERMUX_PYTHON_VERSION\@%${TERMUX_PYTHON_VERSION}%g" \
		"$patch" | patch --silent -p1 -d"$TERMUX_PKG_SRCDIR"
}
