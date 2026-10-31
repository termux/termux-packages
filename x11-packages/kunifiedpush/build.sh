TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kunifiedpush"
TERMUX_PKG_DESCRIPTION="UnifiedPush client components"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kunifiedpush-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=52d9c7a2555890834b4ea773b0968e2748bccababdd8c06d076ba8e628acd02b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcmutils, kf6-kcoreaddons, kf6-ki18n, kf6-kservice, kf6-solid, libc++, openssl, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebsockets"
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
