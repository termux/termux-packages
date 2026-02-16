TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/mailimporter"
TERMUX_PKG_DESCRIPTION="Mail importer library"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/mailimporter-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="c2c624351eeb0264b2c20cbff68f11c0202fa5f23e0d95fb9ec760946bc43645"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-mime, kf6-karchive, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kmime, libc++, pimcommon, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
