TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/messagelib"
TERMUX_PKG_DESCRIPTION="KDE PIM messaging library"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/messagelib-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="1795687da8d01dc15ff3fcfa98a6a5d9eda91daff44d79ef35dd22544ca8129e"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-contacts, akonadi-mime, akonadi-search, gpgmepp, grantleetheme, kf6-karchive, kf6-kcalendarcore, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemmodels, kf6-kitemviews, kf6-kjobwidgets, kf6-kservice, kf6-ktexttemplate, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-sonnet, kf6-syntax-highlighting, kidentitymanagement, kmailtransport, kmbox, kmime, kpimtextedit, ktextaddons, libc++, libgravatar, libkdepim, libkleo, openssl, pimcommon, qgpgme, qt6-qtbase, qt6-qtwebengine"
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
