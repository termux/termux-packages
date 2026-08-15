TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kcalendarcore"
TERMUX_PKG_DESCRIPTION="Library for Interfacing with Calendars"
TERMUX_PKG_LICENSE="BSD 3-Clause, LGPL-2.0-or-later, LGPL-3.0-or-later"
TERMUX_PKG_LICENSE_FILE="
LICENSES/BSD-3-Clause.txt
LICENSES/LGPL-2.0-or-later.txt
LICENSES/LGPL-3.0-or-later.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.29.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kcalendarcore-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=0c5801f9c50d4fea4a183876a887068a4b73d9f5545453dbcd1cd17ec46e2300
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libical, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_PYTHON_BINDINGS=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
