TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/akregator"
TERMUX_PKG_DESCRIPTION="A Feed Reader by KDE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/akregator-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="b15411e8a67c8934ceb30c1b00399424d4a4273698f8560aef4e761921c139e3"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="grantleetheme, kdepim-addons, kf6-kcmutils, kf6-kcodecs, kf6-kcolorscheme, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-knotifications, kf6-knotifyconfig, kf6-kparts, kf6-kstatusnotifieritem, kf6-ktexttemplate, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-syndication, kontactinterface, ktextaddons, libc++, libkdepim, messagelib, pimcommon, qt6-qtbase, qt6-qtwebengine"
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
