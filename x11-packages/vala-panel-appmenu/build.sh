TERMUX_PKG_HOMEPAGE=https://gitlab.com/vala-panel-project/vala-panel-appmenu
TERMUX_PKG_DESCRIPTION="Global Menu for Vala Panel (metapackage)"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.05"
TERMUX_PKG_SRCURL=https://gitlab.com/vala-panel-project/vala-panel-appmenu/-/archive/${TERMUX_PKG_VERSION}/vala-panel-appmenu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=4dd891578429199d2310dc6ff37008be2bb26d045e1fdbbaed8d607af70f7cb2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, gtk2, gtk3, valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwm_backend=wnck
-Dvalapanel=disabled
-Dxfce=enabled
-Dmate=disabled
-Dbudgie=disabled
-Dregistrar=disabled
-Dappmenu-gtk-module=enabled
-Djayatana=disabled
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir

	CPPFLAGS+=" -Dulong=u_long"
	LDFLAGS+=" -lX11"

	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	mkdir -p "${_WRAPPER_BIN}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH="${_WRAPPER_BIN}:${PATH}"
}
