TERMUX_PKG_HOMEPAGE=https://meldmerge.org/
TERMUX_PKG_DESCRIPTION="A visual diff and merge tool targeted at developers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.22.3"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/meld/${TERMUX_PKG_VERSION%.*}/meld-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=37f7f29eb1ff0fec4d8b088d5483c556de1089f6d018fe6d481993caf2499d84
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gsettings-desktop-schemas, glib, gtk3, gtksourceview4, libcairo, pango, pycairo, pygobject, python"
TERMUX_PKG_BUILD_DEPENDS="gettext"
# build dependency only
TERMUX_PKG_PYTHON_TARGET_DEPS="itstool"
TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# The "byte-compile" build setting will go away in the next release
# It does not actually turn off byte compiling because Termux has recent Meson
# (https://gitlab.gnome.org/GNOME/meld/-/commit/361ac82ce94dd46d0eed0e9239c34a8e3d13cd2e)
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbyte-compile=false
--cross-file $TERMUX_MESON_WHEEL_CROSSFILE
"
termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper

	# This is necessary to prevent the error "...libxml2mod.so: cannot open shared object file..." but is insufficient alone
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local _bin="$TERMUX_PKG_BUILDDIR/_bin"
		export ITSTOOL="${_bin}/itstool"
		rm -rf "${_bin}"
		mkdir -p "${_bin}"
		cat > "$ITSTOOL" <<-EOF
			#!$(command -v sh)
			unset PYTHONPATH
			exec $(command -v itstool) "\$@"
		EOF
		chmod 0700 "$ITSTOOL"
	fi
}

# This is necessary to prevent the error "...libxml2mod.so: cannot open shared object file..." and depends on the block in termux_step_pre_configure()
termux_step_configure() {
	termux_setup_meson

	cp -f $TERMUX_MESON_CROSSFILE $TERMUX_MESON_WHEEL_CROSSFILE
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed -i 's|^\(\[binaries\]\)$|\1\nitstool = '\'$ITSTOOL\''|g' \
			$TERMUX_MESON_WHEEL_CROSSFILE
	fi

	termux_step_configure_meson
}
