TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kalarm"
TERMUX_PKG_DESCRIPTION="Personal alarm scheduler"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kalarm-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="87d46227f249c0bbb07880937a955e7a5ba76cd465992a9a0b365f46cea88559"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-contacts, akonadi-mime, kcalutils, kf6-kauth, kf6-kcalendarcore, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kglobalaccel, kf6-kguiaddons, kf6-kholidays, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemmodels, kf6-knotifications, kf6-knotifyconfig, kf6-kstatusnotifieritem, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kidentitymanagement, kmailtransport, kmime, ktextaddons, libc++, qt6-qtbase, vlc-qt"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, mpv"
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
