TERMUX_PKG_HOMEPAGE=https://www.falkon.org/
TERMUX_PKG_DESCRIPTION="Cross-platform QtWebEngine Browser"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.1"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/release-service/$TERMUX_PKG_VERSION/src/falkon-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=65cf68238bc8afa4fa6192a701ad4879d49b443364fa4e2d11c4c71fb65575bb
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-ki18n, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebsockets, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
# Qt6-Webengine doesn't support i686 on Termux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_PYTHON_SUPPORT=OFF
"
