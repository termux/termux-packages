TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-activities-stats"
TERMUX_PKG_DESCRIPTION="Provides usage data for KDE activities"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-activities-stats-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="35c64f724c0550f99677f6134849decf76be47971210ca9418582ea38b480c30"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, libc++, plasma-activities, qt6-qttools"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
