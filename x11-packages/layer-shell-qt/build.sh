TERMUX_PKG_HOMEPAGE=https://invent.kde.org/plasma/layer-shell-qt
TERMUX_PKG_DESCRIPTION="Qt component to allow applications to make use of the Wayland wl-layer-shell protocol"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1.3"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/layer-shell-qt-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a201bd3c867130e96cae75dcfec07f82af74dc2e8074d8d1bd9b0ae2645bf802
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtwayland, libwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libwayland-cross-scanner, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
