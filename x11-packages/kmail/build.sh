TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kmail"
TERMUX_PKG_DESCRIPTION="KDE mail client"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmail-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="755c6fc51f64301c8c225f000e7e0cb9b63da5db4e8bc701335180a1d60898c3"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-contacts, akonadi-import-wizard, akonadi-mime, akonadi-search, gpgmepp, kcalutils, kdepim-addons, kdepim-runtime, kf6-kbookmarks, kf6-kcalendarcore, kf6-kcmutils, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemmodels, kf6-kitemviews, kf6-kjobwidgets, kf6-knotifications, kf6-knotifyconfig, kf6-kparts, kf6-kservice, kf6-kstatusnotifieritem, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-sonnet, kidentitymanagement, kleopatra, kldap, kmail-account-wizard, kmailtransport, kmime, kontactinterface, kpimtextedit, ktextaddons, ktnef, libc++, libgpg-error, libgravatar, libkdepim, libkleo, libksieve, mailcommon, mbox-importer, messagelib, pim-data-exporter, pim-sieve-editor, pimcommon, qgpgme, qt6-qtbase, qt6-qtwebengine, qtkeychain"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
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
