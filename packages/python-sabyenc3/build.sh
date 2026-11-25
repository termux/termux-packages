TERMUX_PKG_HOMEPAGE=https://github.com/sabnzbd/sabctools
TERMUX_PKG_DESCRIPTION="C implementations of functions for use within SABnzbd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.2.0"
TERMUX_PKG_SRCURL="https://github.com/sabnzbd/sabctools/releases/download/v${TERMUX_PKG_VERSION}/sabctools-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=abd27b63b3b55bb1c10399cee53a5863dfa2a1fa1c794ed62818d8df8361a9ac
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
