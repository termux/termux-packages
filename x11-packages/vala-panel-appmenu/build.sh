TERMUX_PKG_HOMEPAGE=https://gitlab.com/vala-panel-project/vala-panel-appmenu
TERMUX_PKG_DESCRIPTION="Global Menu for Vala Panel (metapackage)"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.04"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.com/vala-panel-project/vala-panel-appmenu/-/archive/${TERMUX_PKG_VERSION}/vala-panel-appmenu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ff270de372c41f18f64e8788629dd4cc9f116a89ee8947e3fc2657b19182e2dc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, gtk3, valac"
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
	termux_setup_glib_cross_pkg_config_wrapper

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
