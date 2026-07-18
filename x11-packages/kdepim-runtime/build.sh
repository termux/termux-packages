TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kdepim-runtime"
TERMUX_PKG_DESCRIPTION="Extends the functionality of kdepim"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdepim-runtime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="498744228f225176624fafbab283815b6872351f6d15bb935e2d02c1a644dd43"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, kf6-kcalendarcore, kf6-kcmutils, kf6-kcodecs, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kdav, kf6-ki18n, kf6-kio, kf6-knotifications, kf6-knotifyconfig, kf6-kservice, kf6-kwallet, kf6-kwidgetsaddons, kf6-kwindowsystem, kidentitymanagement, kimap, kldap, kmailtransport, kmbox, kmime, ktextaddons, libc++, libkgapi, libsasl, pimcommon, qca, qt6-qtbase, qt6-qtnetworkauth, qt6-qtspeech, qt6-qtwebengine, qtkeychain"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules, kf6-kdoctools, kf6-kdoctools, libetebase"
# akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime depends on qt6-qtwebengine
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
