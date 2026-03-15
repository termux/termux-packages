TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kdepim-addons"
TERMUX_PKG_DESCRIPTION="Addons for KDE PIM applications"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdepim-addons-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="0eebf8a6aee397b53ce1365ed6a27af5f7a348865c575ba7ac0f88787f7fa979"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-calendar, akonadi-contacts, akonadi-import-wizard, akonadi-mime, calendarsupport, gpgmepp, grantleetheme, incidenceeditor, kcalutils, kf6-kcalendarcore, kf6-kcmutils, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kdeclarative, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-kitemviews, kf6-kservice, kf6-ktexttemplate, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-prison, kf6-syntax-highlighting, kidentitymanagement, kimap, kirigami-addons, kitinerary, kldap, kmailtransport, kmime, kpimtextedit, kpkpass, ktextaddons, ktnef, libc++, libgravatar, libkleo, libksieve, mailcommon, mailimporter, messagelib, pimcommon, qgpgme, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="corrosion, extra-cmake-modules, kaddressbook, kf6-kdoctools"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	termux_setup_rust

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRust_CARGO_TARGET=$CARGO_TARGET_NAME"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
