# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Display Manager Control Protocol library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.5"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/lib/libXdmcp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d8a5222828c3adab70adf69a5583f1d32eb5ece04304f7f8392b6a353aa2228c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
