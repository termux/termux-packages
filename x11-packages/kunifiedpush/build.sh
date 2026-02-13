TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kunifiedpush"
TERMUX_PKG_DESCRIPTION="UnifiedPush client components"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kunifiedpush-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="e111dd53c7a77bfc32f358375b9649ed418d9c5acd9c44b95ec5a07c9c2078b9"
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
