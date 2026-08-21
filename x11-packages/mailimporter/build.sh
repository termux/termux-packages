TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/mailimporter"
TERMUX_PKG_DESCRIPTION="Mail importer library"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/mailimporter-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c61402add7fe11b249e565f8cbe7574f86b170e89a667de0833d40a9f4098465
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-mime, kf6-karchive, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kmime, libc++, pimcommon, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
# akonadi, akonadi-mime, pimcommon depends on qt6-qtwebengine
# qt6-qtwebengine is not supported on the i686 architecture
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
