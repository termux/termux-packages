TERMUX_PKG_HOMEPAGE=https://www.falkon.org/
TERMUX_PKG_DESCRIPTION="Cross-platform QtWebEngine Browser"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/release-service/$TERMUX_PKG_VERSION/src/falkon-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=6d9b4dba1bde0d04570736ed7bb9bc1288cd7fb94b4ffe934a990912b9b7a959
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
