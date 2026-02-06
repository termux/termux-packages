TERMUX_PKG_HOMEPAGE="https://apps.kde.org/kate/"
TERMUX_PKG_DESCRIPTION="KDE Advanced Text Editor"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kate-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=084d7d75c70326438f4a34fecb3576d9968808650c1852c44726472f9267062a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="clang, git, kf6-karchive, kf6-kbookmarks, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-knewstuff, kf6-kparts, kf6-kservice, kf6-ktexteditor, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-syntax-highlighting, konsole, libc++, qt6-qtbase, qt6-qtdeclarative, rust, texlab"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qtkeychain"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DBUILD_doc=OFF
"
