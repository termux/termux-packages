TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kaddressbook"
TERMUX_PKG_DESCRIPTION="KDE contact manager"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kaddressbook-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=fb37324db737ccdb3f8680ed7b1f03ac24418aeb6f1545e78486c2b9b05cdec9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-contacts, akonadi-search, grantleetheme, kdepim-runtime, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kitemmodels, kf6-kparts, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kxmlgui, kldap, kontactinterface, libc++, libkdepim, pimcommon, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
# akonadi, akonadi-contacts, akonadi-search, kdepim-runtime, pimcommon depends on qt6-qtwebengine
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
