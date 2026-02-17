TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-browser-integration"
TERMUX_PKG_DESCRIPTION="Components necessary to integrate browsers into the Plasma Desktop"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-browser-integration-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f09c2e7dcdca53d0284dad9d172b5ef5b9f2368cfabbe644348ca7705784e7dc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kio, kf6-kjobwidgets, kf6-kservice, kf6-kstatusnotifieritem, kf6-purpose, libc++, plasma-activities, plasma-workspace, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
