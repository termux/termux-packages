TERMUX_PKG_HOMEPAGE="https://www.qt.io/"
TERMUX_PKG_DESCRIPTION="Provides access to Bluetooth hardware"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only, LicenseRef-Qt-Commercial, Qt-GPL-exception-1.0"
TERMUX_PKG_LICENSE_FILE="
LICENSES/GPL-3.0-only.txt
LICENSES/LGPL-3.0-only.txt
LICENSES/LicenseRef-Qt-Commercial.txt
LICENSES/Qt-GPL-exception-1.0.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.9.1"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtconnectivity-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="4988e50112104d5ad85e5b3cef66036ca445f18c22cf375d3dac9dcca95e0a17"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libpcsclite, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
