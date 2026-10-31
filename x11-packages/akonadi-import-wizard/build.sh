TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/akonadi-import-wizard"
TERMUX_PKG_DESCRIPTION="Import data from other mail clients to KMail"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/akonadi-import-wizard-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9bc59de4ff00b6486ded21a52b96d334128ad7b283266da81be23da9ebde53bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kiconthemes, kf6-kwidgetsaddons, kf6-kxmlgui, kidentitymanagement, kmailtransport, libc++, mailcommon, mailimporter, messagelib, pimcommon, qt6-qtbase, qtkeychain"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
TERMUX_PKG_RECOMMENDS="kdepim-addons"
# akonadi, mailcommon, mailimporter, messagelib, pimcommon, kdepim-addons depends on qt6-qtwebengine
# qt6-qtwebengine is not supported on the i686 architecture
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
