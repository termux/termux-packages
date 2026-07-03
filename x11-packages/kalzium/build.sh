TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/kalzium"
TERMUX_PKG_DESCRIPTION="Periodic Table of Elements"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kalzium-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d79114a42fc3582962bec85ac2d877217708a9491d51f731b166c36c87ed1a23
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kio, kf6-kitemviews, kf6-knewstuff, kf6-kplotting, kf6-ktextwidgets, kf6-kunitconversion, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, libxml2, openbabel, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtscxml, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="eigen, extra-cmake-modules, kf6-kdoctools, openbabel-static"
#avogadro, ocaml and facile can be added later if packaged in future
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	export LDFLAGS+=" -lxml2"
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
} 
