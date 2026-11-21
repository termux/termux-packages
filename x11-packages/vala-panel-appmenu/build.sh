TERMUX_PKG_HOMEPAGE=https://gitlab.com/vala-panel-project/vala-panel-appmenu
TERMUX_PKG_DESCRIPTION="Global Menu for Vala Panel (metapackage)"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.11"
TERMUX_PKG_SRCURL=https://gitlab.com/vala-panel-project/vala-panel-appmenu/-/archive/${TERMUX_PKG_VERSION}/vala-panel-appmenu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1eb7fb356ac559f9c797f19532602d4ae9dc0a7c887466eb33fe47b2ca09cace
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libwayland"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, gtk3, json-glib, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwm_backend=wnck
-Dvalapanel=disabled
-Dxfce=enabled
-Dmate=enabled
-Dbudgie=disabled
-Dregistrar=disabled
-Dappmenu-gtk-module=enabled
-Djayatana=disabled
-Dappmenu-gtk-module:gtk=3
"

termux_step_pre_configure() {
	termux_setup_gir

	CPPFLAGS+=" -Dulong=u_long"
	LDFLAGS+=" -lX11"

	termux_setup_pkg_config_wrapper "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		# adjust valac wrapper created by the cross-compilation mode
		# of termux_setup_gir, to avoid a specific error
		# that only happens to vala-panel-appmenu and
		# only happens when cross-compiling it
		# error: The name `Property' does not exist in the context of `Xfconf' (libxfconf-0)
		rm -f "$TERMUX_PREFIX/lib/pkgconfig/appmenu-glib-translator.pc"
		mkdir -p "$TERMUX_PKG_TMPDIR/custom-bin"
		cp "$(command -v valac)" "$TERMUX_PKG_TMPDIR/custom-bin"
		sed -i "s|--vapidir=\"$TERMUX_PREFIX/share/vala/vapi\"||g" \
			"$TERMUX_PKG_TMPDIR/custom-bin/valac"
		export PATH="$TERMUX_PKG_TMPDIR/custom-bin:$PATH"
	fi
}
