TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Building tools required by LXQt project"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="BSD-3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.1"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-build-tools/releases/download/${TERMUX_PKG_VERSION}/lxqt-build-tools-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=13dcdf2e6b55cc334ac0ddadd0c131d46c46e06fab0d6ca7b8b96c260c8e332f
TERMUX_PKG_DEPENDS="qt6-qttools"
TERMUX_PKG_ANTI_BUILD_DEPENDS="qt6-qttools"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase, qt6-qtbase-cross-tools"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLXQT_ETC_XDG_DIR=${TERMUX_PREFIX}/etc/xdg
-DQt6CoreTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6CoreTools
"
