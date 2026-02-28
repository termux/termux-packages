TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/mbox-importer"
TERMUX_PKG_DESCRIPTION="Import mbox files to KMail"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/mbox-importer-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="628238e028aeaa2a6395a78449abfe4344d69fcff7c7f4b70994a98fc194be95"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kwidgetsaddons, kidentitymanagement, libc++, mailcommon, mailimporter, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
