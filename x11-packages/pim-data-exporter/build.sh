TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/pim-data-exporter"
TERMUX_PKG_DESCRIPTION="Import and export KDE PIM settings"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/pim-data-exporter-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="6fe5178dab3bac4ecac6c1e5d9f869346e0023653d764fec80cccae96750ac00"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-mime, kf6-karchive, kf6-kcalendarcore, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-kstatusnotifieritem, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kxmlgui, kidentitymanagement, kmailtransport, kmime, ktextaddons, libc++, mailcommon, pimcommon, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
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
