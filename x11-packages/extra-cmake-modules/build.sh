TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Extra CMake modules (KDE)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSES/BSD-3-Clause.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.13.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/extra-cmake-modules-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7006017c00c817ff4c056995146d271791d1487a398d39ea6cac1cd59a8bf402
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_GROUP=x11/kframeworks6
TERMUX_PKG_ALIGN_VERSION_WITH=kf6-kconfig
TERMUX_PKG_DEPENDS="cmake"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_HTML_DOCS=OFF
-DBUILD_QTHELP_DOCS=OFF
-DBUILD_TESTING=OFF
"
