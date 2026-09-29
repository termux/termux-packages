TERMUX_PKG_HOMEPAGE=https://invent.kde.org/education/kstars
TERMUX_PKG_DESCRIPTION="KStars cross-platform Astronomy Software by KDE."
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="3.8.3"
TERMUX_PKG_SRCURL="https://invent.kde.org/education/kstars/-/archive/stable-${TERMUX_PKG_VERSION}/kstars-stable-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=072e11e0701033d4c5ac918a46f0906e015be6f979304d5b13b82955a382d8b6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_DEPENDS="cfitsio, curl, eigen, gettext, indi, kf6-kconfig, kf6-kcrash, kf6-kwidgetsaddons, kf6-knewstuff, kf6-knotifyconfig, kf6-ki18n, kf6-kio, kf6-kxmlgui, kf6-kplotting, kf6-knotifications, libc++, libnova, libraw, libxisf, littlecms, opencv, opengl, qt6-qtbase,  qt6-qtwebsockets, qtkeychain, stellarsolver, wcslib, xplanet"
TERMUX_PKG_BUILD_DEPENDS="ccache, extra-cmake-modules"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_WITH_QT6=ON
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/libindi -I${TERMUX_PREFIX}/include/opencv4"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=${TERMUX_PREFIX}/opt/kf6/cross/lib/cmake/"
	fi
}
