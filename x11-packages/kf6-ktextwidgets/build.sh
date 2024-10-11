TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Advanced text editing widgets'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.6.0
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/ktextwidgets-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=805dff320b75a62316fe50aa33eedb355c1e2db36d00b58c39fc36ce6bfd8988
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-ki18n, kf6-kwidgetsaddons, qt6-qtbase, kf6-sonnet"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_TEXT_TO_SPEECH=OFF
"
# qt6-qttexttospeech can be added to TERMUX_PKG_DEPENDS when available, and -DWITH_TEXT_TO_SPEECH=OFF can be removed
