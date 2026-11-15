TERMUX_PKG_HOMEPAGE=https://www.hohnstaedt.de/xca/
TERMUX_PKG_DESCRIPTION="X Certificate and Key management"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.0"
TERMUX_PKG_SRCURL="https://github.com/chris2511/xca/releases/download/RELEASE.${TERMUX_PKG_VERSION}/xca-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c8a956f6f0660356b725cb06ef5835dfb36526043a4f8c1cfe7674bb7bdd6c5c
TERMUX_PKG_DEPENDS="desktop-file-utils, gtk-update-icon-cache, qt6-qttools"
TERMUX_PKG_BUILD_DEPENDS="qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="${TERMUX_PKG_HOSTBUILD_DIR}/build" \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		-DQT_DIR="$TERMUX_PREFIX/lib/qt"

	ninja -j "${TERMUX_PKG_MAKE_PROCESSES}" install
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PATH="$PATH:$TERMUX_PKG_HOSTBUILD_DIR"
	fi
}
