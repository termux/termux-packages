TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kdepim-addons"
TERMUX_PKG_DESCRIPTION="Addons for KDE PIM applications"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdepim-addons-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d01ea99b6e7938f05f0d3b6332c60e1a4148a14883f1b48acd69951d95c39dc2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-calendar, akonadi-contacts, akonadi-import-wizard, akonadi-mime, calendarsupport, gpgmepp, grantleetheme, incidenceeditor, kcalutils, kf6-kcalendarcore, kf6-kcmutils, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kdeclarative, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-kitemviews, kf6-kservice, kf6-ktexttemplate, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-prison, kf6-syntax-highlighting, kidentitymanagement, kimap, kirigami-addons, kitinerary, kldap, kmailtransport, kf6-kmime, kpimtextedit, kpkpass, ktextaddons, ktnef, libc++, libgravatar, libkleo, libksieve, mailcommon, mailimporter, messagelib, pimcommon, qgpgme, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="corrosion, extra-cmake-modules, kaddressbook, kf6-kdoctools"
# qt6-qtwebengine is not supported on the i686 architecture
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DCMAKE_MODULE_PATH=$TERMUX_PREFIX/share/cmake
"

termux_step_pre_configure() {
	termux_setup_rust

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRust_CARGO_TARGET=$CARGO_TARGET_NAME"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
