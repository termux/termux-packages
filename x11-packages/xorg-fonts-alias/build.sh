TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org font alias files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.6"
TERMUX_PKG_SRCURL="https://xorg.freedesktop.org/releases/individual/font/font-alias-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f6a5e968b616e728a981fd1fd9ed5fe2ca0fe18fbe072b1888cb3f71b701e4c0
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# if any of these are not installed while xorg-fonts-misc is installed, in particular xorg-fonts-misc,
# then strange and unxpected behavior can happen in Termux:X11 particularly with certain programs
# such as xcalc and xmessage, resulting in 'Error: Aborting: no font found'
# https://github.com/termux/termux-x11/issues/880
# https://github.com/termux/termux-packages/issues/23002
TERMUX_PKG_RECOMMENDS="xorg-fonts-75dpi, xorg-fonts-100dpi, xorg-fonts-cyrillic, xorg-fonts-misc"
