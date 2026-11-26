TERMUX_PKG_HOMEPAGE=https://zorin.com/os
TERMUX_PKG_DESCRIPTION="Xfce4 panel plugin for Zorin AppGrid Lite"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL=https://launchpad.net/~zorinos/+archive/ubuntu/stable/+files/xfce4-zorinappgridlite-plugin_${TERMUX_PKG_VERSION}-1.tar.xz
TERMUX_PKG_SHA256=14dd0316f1306c15602d064cd66b426880a117b1fd89dfab2b2d8608099f7d8f
TERMUX_PKG_DEPENDS="libxfce4ui, libxfce4util, xfce4-panel, zorin-appgrid-lite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
