TERMUX_PKG_HOMEPAGE=https://github.com/sabnzbd/sabctools
TERMUX_PKG_DESCRIPTION="C implementations of functions for use within SABnzbd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.7.0"
TERMUX_PKG_SRCURL="https://github.com/sabnzbd/sabctools/releases/download/v${TERMUX_PKG_VERSION}/sabctools-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d84b82c238cba7924f5e0989bbc125816a6aeab1a9f1c151073c803ee567b40d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, scikit-build-core"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	local patch="$TERMUX_PKG_BUILDER_DIR/rapidyenc-arch.diff"
	echo "Applying patch: $(basename "$patch")"
	sed -e "s|@TERMUX_ARCH@|$TERMUX_ARCH|" "$patch" | patch --silent -p1

	export CXXFLAGS+=" -fPIC -I$TERMUX_PREFIX/include/ndk_compat"
	export CFLAGS+=" -I$TERMUX_PREFIX/include/ndk_compat"
	export LDFLAGS+=" -l:libndk_compat.a"
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	pip install --no-build-isolation --no-deps --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
