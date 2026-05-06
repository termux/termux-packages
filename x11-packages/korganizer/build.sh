TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/korganizer"
TERMUX_PKG_DESCRIPTION="Calendar and scheduling Program"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/korganizer-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="b890069f4397c7c0905a947dd3f0abc735363bb12e1422a8225b4f6befa06d4b"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-calendar, akonadi-contacts, calendarsupport, eventviews, incidenceeditor, kcalutils, kdepim-addons, kdepim-runtime, kf6-kcalendarcore, kf6-kcmutils, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-kholidays, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemmodels, kf6-kitemviews, kf6-kjobwidgets, kf6-kparts, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kmailtransport, kmime, kontactinterface, libc++, libkdepim, pimcommon, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, qt6-qttools"
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
