TERMUX_PKG_HOMEPAGE="https://invent.kde.org/games/kpat"
TERMUX_PKG_DESCRIPTION="KPatience offers a selection of solitaire card games"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kpat-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=562ab74043bfb77ec57970f757f107ded9d8e3fe13748324009720077ad719cb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="black-hole-solver, freecell-solver, kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, libkdegames, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="kf6-kconfig-cross-tools, extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}

termux_step_post_make_install() {
	rm -f $TERMUX_PREFIX/share/mime/mime.cache
}
