TERMUX_PKG_HOMEPAGE=https://meldmerge.org/
TERMUX_PKG_DESCRIPTION="A visual diff and merge tool targeted at developers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.23.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/meld/${TERMUX_PKG_VERSION%.*}/meld-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=73f827924663c7c6b451a74c8385304d99feaa13c81f4e0a171da597c6843574
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="gsettings-desktop-schemas, glib, gtk3, gtksourceview4, libcairo, pango, pycairo, pygobject, python"
TERMUX_PKG_BUILD_DEPENDS="gettext"
# build dependency only
TERMUX_PKG_PYTHON_TARGET_DEPS="itstool"
TERMUX_PKG_PYTHON_RUNTIME_DEPS=false
TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
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
