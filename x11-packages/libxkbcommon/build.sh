TERMUX_PKG_HOMEPAGE=https://xkbcommon.org/
TERMUX_PKG_DESCRIPTION="Keymap handling library for toolkits and window systems"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_SRCURL=https://github.com/xkbcommon/libxkbcommon/archive/xkbcommon-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=053e6a6a2c3179eba20c3ada827fb8833a6663b7ffd278fdb8530c3cbf924780
TERMUX_PKG_DEPENDS="libxcb, libxml2, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-docs=false
-Denable-wayland=false
"
