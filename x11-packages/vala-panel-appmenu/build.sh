TERMUX_PKG_HOMEPAGE=https://gitlab.com/vala-panel-project/vala-panel-appmenu
TERMUX_PKG_DESCRIPTION="Global Menu for Vala Panel (metapackage)"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.02"
TERMUX_PKG_SRCURL=https://gitlab.com/vala-panel-project/vala-panel-appmenu/-/archive/${TERMUX_PKG_VERSION}/vala-panel-appmenu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=83b1803ea18afa9edfaad008ff378ef4b560d4ef968eadf552915d3569029c52
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
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
