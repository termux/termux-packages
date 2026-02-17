TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-activities-stats"
TERMUX_PKG_DESCRIPTION="Provides usage data for KDE activities"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-activities-stats-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=03fe7bda7db2dd30cb26cbb87d2829965532439a8d6532be089e317629ea9b5a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, libc++, plasma-activities, qt6-qttools"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
