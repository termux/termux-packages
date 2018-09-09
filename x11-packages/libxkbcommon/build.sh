TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xkbcommon.org/
TERMUX_PKG_DESCRIPTION="Keymap handling library for toolkits and window systems"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://github.com/xkbcommon/libxkbcommon/archive/xkbcommon-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0683c42c7e39b8f68786eab9140461031c8f2dd9616442cf77770d2aea956e7d
TERMUX_PKG_DEPENDS="libxcb, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-docs=false
-Denable-wayland=false
"
