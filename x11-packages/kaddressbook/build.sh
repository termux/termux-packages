TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kaddressbook"
TERMUX_PKG_DESCRIPTION="KDE contact manager"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kaddressbook-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="5c3e77aa683eff9a96a5117768e8b1828f171dade1a035443bda37a1c5abcbd4"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-contacts, akonadi-search, grantleetheme, kdepim-runtime, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kitemmodels, kf6-kparts, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kxmlgui, kldap, kontactinterface, libc++, libkdepim, pimcommon, qt6-qtbase"
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
