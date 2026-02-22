TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/merkuro"
TERMUX_PKG_DESCRIPTION="Application suite designed to handle emails, calendars, contacts and tasks"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/merkuro-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="c84745a7d83510803eafa69d27a0212989771c99f571fc83bcf717d751bc539e"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, akonadi-search, gpgmepp, kdepim-runtime, kf6-kcalendarcore, kf6-kcodecs, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdeclarative, kf6-kholidays, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-knotifications, kf6-ksvg, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-prison, kf6-qqc2-desktop-style, kirigami-addons, kidentitymanagement, kmailtransport, kmbox, kmime, libc++, libkdepim, libkleo, libplasma, mailcommon, messagelib, mimetreeparser, pimcommon, qgpgme, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtlocation, qt6-qtpositioning"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
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
