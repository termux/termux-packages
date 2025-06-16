TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config
TERMUX_PKG_DESCRIPTION="X keyboard configuration files"
TERMUX_PKG_LICENSE="HPND, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.45"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/archive/xkeyboard-config-${TERMUX_PKG_VERSION}/xkeyboard-config-xkeyboard-config-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9ab49abdae20545c8f215472d8537e0228635b7947d63e02592db24a5025ed6a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_PYTHON_COMMON_DEPS="StrEnum"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dxkb-base=${TERMUX_PREFIX}/share/X11/xkb
-Dcompat-rules=true
-Dxorg-rules-symlinks=true
"
