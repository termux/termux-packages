TERMUX_PKG_HOMEPAGE="https://invent.kde.org/accessibility/accessibility-inspector"
TERMUX_PKG_DESCRIPTION="Inspect your application accessibility tree"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/accessibility-inspector-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=8ac7d89aa00ee86855d9a84b7546693dc945b9acbe8942f9081090f4c89b5f61
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kxmlgui, libc++, libqaccessibilityclient-qt6, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
