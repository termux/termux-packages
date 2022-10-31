TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Utility libraries for XC Binding - Convenience functions for the Render extension"
# Licenses: HPND, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.10
TERMUX_PKG_SRCURL=https://xcb.freedesktop.org/dist/xcb-util-renderutil-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3e15d4f0e22d8ddbfbb9f5d77db43eacd7a304029bf25a6166cc63caa96d04ba
TERMUX_PKG_DEPENDS="libxcb"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
