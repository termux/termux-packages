TERMUX_PKG_HOMEPAGE=https://xkbcommon.org/
TERMUX_PKG_DESCRIPTION="Keymap handling library for toolkits and window systems"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_REVISION=13
TERMUX_PKG_SRCURL=https://github.com/xkbcommon/libxkbcommon/archive/xkbcommon-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9b4635cf5d9fc0fb9611ceec1780aafc0944299e9a29ab09c18ec2633923b9c3
TERMUX_PKG_DEPENDS="libxcb, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-docs=false
-Denable-wayland=false
"
