TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/ktextwidgets'
TERMUX_PKG_DESCRIPTION='Advanced text editing widgets'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/ktextwidgets-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=dcf16d5c27d36ce11a05b9d43b6be1e74b806a0a9ddd261026463a0aa7e27d22
TERMUX_PKG_DEPENDS="kf6-kcolorscheme (>= ${TERMUX_PKG_VERSION%.*}), kf6-kcompletion (>= ${TERMUX_PKG_VERSION%.*}), kf6-kconfig (>= ${TERMUX_PKG_VERSION%.*}), kf6-kconfigwidgets (>= ${TERMUX_PKG_VERSION%.*}), kf6-ki18n (>= ${TERMUX_PKG_VERSION%.*}), kf6-kwidgetsaddons (>= ${TERMUX_PKG_VERSION%.*}), kf6-sonnet (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_TEXT_TO_SPEECH=OFF
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
# qt6-qttexttospeech can be added to TERMUX_PKG_DEPENDS when available, and -DWITH_TEXT_TO_SPEECH=OFF can be removed from TERMUX_PKG_EXTRA_CONFIGURE_ARGS
