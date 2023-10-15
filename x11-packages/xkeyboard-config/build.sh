TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/XKeyboardConfig/
TERMUX_PKG_DESCRIPTION="X keyboard configuration files"
# Licenses: HPND, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.40"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7a3dba1bec7dc7191432da021242d17c9cf6c89690e6c57b0de048ff8c9d2ae3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dxkb-base=${TERMUX_PREFIX}/share/X11/xkb
-Dcompat-rules=true
-Dxorg-rules-symlinks=true
"
