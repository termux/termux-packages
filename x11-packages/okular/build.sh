TERMUX_PKG_HOMEPAGE="https://apps.kde.org/okular"
TERMUX_PKG_DESCRIPTION="Multi-platform document viewer for PDF, comics, EPub, and images"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/okular-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9c84a80fe2a3dd0990b56432912244b6f5761a1a6abda452f3da6e7e6a88937f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="discount, djvulibre, freetype, kf6-karchive, kf6-kbookmarks, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kparts, kf6-ktextwidgets, kf6-kwallet, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-purpose, kf6-threadweaver, libc++, libkexiv2, libspectre, libtiff, phonon-qt6, poppler-qt, qt6-qtbase, qt6-qtdeclarative, qt6-qtspeech, qt6-qtsvg, unrar, zlib"
TERMUX_PKG_BUILD_DEPENDS="ebook-tools, extra-cmake-modules, kdegraphics-mobipocket"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DFORCE_NOT_REQUIRED_DEPENDENCIES=KF6DocTools
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
