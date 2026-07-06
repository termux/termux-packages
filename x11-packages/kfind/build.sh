TERMUX_PKG_HOMEPAGE="https://invent.kde.org/utilities/kfind"
TERMUX_PKG_DESCRIPTION="File search utility by KDE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kfind-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=21b79c83b60bd142f20edf2cf380c377c0fcaa2a34b727401905ab69621c27d8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gettext, kf6-karchive, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kio, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-kcrash, kf6-kdoctools, libc++, qt6-qtbase, qt6-qt5compat"
TERMUX_PKG_BUILD_DEPENDS="kf6-kconfig-cross-tools, qt6-qtbase-cross-tools, extra-cmake-modules"
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
