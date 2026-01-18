TERMUX_PKG_HOMEPAGE=https://zorin.com/os
TERMUX_PKG_DESCRIPTION="Zorin AppGrid Lite from Zorin OS"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION="1.0.2"
TERMUX_PKG_SRCURL=http://ppa.launchpad.net/zorinos/stable/ubuntu/pool/main/z/zorin-appgrid-lite/zorin-appgrid-lite_${TERMUX_PKG_VERSION}-1.tar.xz
TERMUX_PKG_SHA256=14de990e03bb087e700684f9642784b787aa6f57504c406f33e13ccad9216577
TERMUX_PKG_DEPENDS="libgee, gnome-menus, glib, gtk3, libwnck"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BUILD_DEPENDS="valac"

termux_step_pre_configure() {
	termux_setup_gir
}

