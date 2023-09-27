TERMUX_PKG_HOMEPAGE=https://gitlab.com/vala-panel-project/vala-panel-appmenu
TERMUX_PKG_DESCRIPTION="Global Menu for Vala Panel (metapackage)"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.6
TERMUX_PKG_SRCURL=https://gitlab.com/vala-panel-project/vala-panel-appmenu/-/archive/${TERMUX_PKG_VERSION}/vala-panel-appmenu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c137f8f30ab5925a4a236a8a047b7962ec9be987fe25dd2d092666e0580fdacf
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwm_backend=wnck
-Dvalapanel=disabled
-Dxfce=enabled
-Dmate=disabled
-Dbudgie=disabled
-Dregistrar=disabled
-Dappmenu-gtk-module=disabled
-Djayatana=disabled
"

termux_step_pre_configure() {
	termux_setup_gir

	CPPFLAGS+=" -Dulong=u_long"
	LDFLAGS+=" -lX11"
}
