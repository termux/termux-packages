TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/ktexteditor"
TERMUX_PKG_DESCRIPTION="Advanced embeddable text editor by KDE"
TERMUX_PKG_LICENSE="GPL-2.0-only, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/ktexteditor-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=1d9b336a2b26ecc6a1c5b8133eacea69ed786b3eb6f1ec2ad6705c2bea62e1c5
TERMUX_PKG_DEPENDS="editorconfig-core-c, git, kf6-karchive, kf6-kauth, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-kitemviews, kf6-kparts, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-sonnet, kf6-syntax-highlighting, libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtspeech"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
