TERMUX_PKG_HOMEPAGE=https://hluk.github.io/CopyQ/
TERMUX_PKG_DESCRIPTION="Advanced clipboard manager with editing and scripting features"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="17.0.0"
TERMUX_PKG_SRCURL="https://github.com/hluk/CopyQ/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=78c73c6213fe4cf0c91e462c9372228af17c72448a1a69c9e4b0d28c79ff5fbc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kguiaddons, kf6-knotifications, kf6-kstatusnotifieritem, libc++, libx11, libxcb, libxfixes, libxtst, qca, qt6-qtbase, qt6-qtdeclarative, qt6-qtsvg, qtkeychain"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtbase-cross-tools, qt6-qttools, qt6-qttools-cross-tools, xorgproto"
TERMUX_PKG_RECOMMENDS="gnupg, hicolor-icon-theme"

# miniaudio is not packaged and the GNOME extension is useless here.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DWITH_AUDIO=OFF
-DWITH_GNOME_CLIPBOARD_EXTENSION=OFF
-DWITH_TESTS=OFF
"
