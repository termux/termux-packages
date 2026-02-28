TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/mbox-importer"
TERMUX_PKG_DESCRIPTION="Import mbox files to KMail"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/mbox-importer-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="f7a8a22dab372271175162595cac8c38a1645c54b0935cc05dc9df4ea5004508"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kwidgetsaddons, kidentitymanagement, libc++, mailcommon, mailimporter, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
# akonadi, mailcommon, mailimporter depends on qt6-qtwebengine
# qt6-qtwebengine is not supported on the i686 architecture
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
