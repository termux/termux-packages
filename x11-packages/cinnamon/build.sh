TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon
TERMUX_PKG_DESCRIPTION="Cinnamon shell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b566d4ef406d1600a34cb6930c09160fec9dffe2f3d011bdf36b11f18df190a5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="atk, cinnamon-control-center, cinnamon-menus, cinnamon-session, cinnamon-settings-daemon, cjs, clutter, clutter-gtk, cogl, dbus, gcr, gdk-pixbuf, gettext, glib, gnome-backgrounds, gobject-introspection, gsound, gtk3, ibus, libadapta, libx11, libxml2, mint-themes, mint-y-icon-theme, muffin, nemo, opengl, pango, python-pillow, python-pip, python-xapp, sassc, xapp"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, intltool, python-libsass"
TERMUX_PKG_PYTHON_RUNTIME_DEPS="pytz, tinycss2, requests"
TERMUX_PKG_SUGGESTS="gnome-terminal, gnome-screenshot"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="pysass"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dbuild_recorder=false
-Dnm_agent=disabled
-Dpy3modules_dir="$TERMUX_PYTHON_HOME/site-packages"
-Dwayland=false
-Dpolkit=false
"

termux_step_post_get_source() {
	find "$TERMUX_PKG_SRCDIR" -type f | \
		xargs -n 1 sed -i \
		-e "s|/usr|$TERMUX_PREFIX|g" \
		-e "s|#!$TERMUX_PREFIX|#!/usr|g"
}

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1

	# allow use of GNU/Linux pysass (TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="pysass") during cross-compilation
	# but bionic-libc pysass (TERMUX_PKG_BUILD_DEPENDS="python-sass") during on-device build
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PYTHONPATH="${TERMUX_PYTHON_CROSSENV_PREFIX}/cross/lib/python${TERMUX_PYTHON_VERSION}/site-packages"
	fi
}

termux_step_post_make_install() {
	# disabling this sections because they will not work in termux
	mv $TERMUX_PREFIX/share/cinnamon/cinnamon-settings/modules/cs_user.py $TERMUX_PREFIX//share/cinnamon/cinnamon-settings/modules/cs_user.py.bak
	rm -rf $TERMUX_PREFIX/share/cinnamon/applets/user@cinnamon.org
	rm -rf $TERMUX_PREFIX/share/cinnamon/applets/network@cinnamon.org
	rm -rf $TERMUX_PREFIX/share/cinnamon/applets/printers@cinnamon.org

	########################################################################
	# Based on :- https://src.fedoraproject.org/rpms/cinnamon/tree/rawhide #
	########################################################################
	# Install gschema overrides
	schemas_dir="$TERMUX_PREFIX/share/glib-2.0/schemas"
	mkdir -p "$schemas_dir"
	install -Dm644 "$TERMUX_PKG_BUILDER_DIR/10_cinnamon-common.gschema.override" "$schemas_dir/10_cinnamon-common.gschema.override"
	cat <<-EOF > "$schemas_dir/10_cinnamon-wallpaper.gschema.override"
		[org.cinnamon.desktop.background]
		picture-uri='file://$TERMUX_PREFIX/share/backgrounds/gnome/adwaita-d.jpg'
	EOF
	# Install style file
	styles_dir="$TERMUX_PREFIX/share/cinnamon/styles.d"
	mkdir -p "$styles_dir"
	install -Dm644 "$TERMUX_PKG_BUILDER_DIR/22_termux.styles" "$styles_dir/22_termux.styles"
}
