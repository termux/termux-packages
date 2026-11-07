TERMUX_PKG_HOMEPAGE="https://apps.kde.org/alligator/"
TERMUX_PKG_DESCRIPTION="Alligator is a convergent, cross-platform feed reader, supporting standard RSS/Atom feeds"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/alligator-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a8bdd269ad9620f3107c0db2ba8046fcb0d7bf0f52501a6583f4e60f58b8e95a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kirigami, kf6-syndication, kirigami-addons, libc++, kf6-qqc2-desktop-style, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
