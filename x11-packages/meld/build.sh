TERMUX_PKG_HOMEPAGE=https://meldmerge.org/
TERMUX_PKG_DESCRIPTION="A visual diff and merge tool targeted at developers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.22.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/meld/${TERMUX_PKG_VERSION%.*}/meld-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=46a0a713fbcd1b153b377a1e0757c8ce255c9822467658eacfbd89b1e92316ef
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gsettings-desktop-schemas, glib, gtk3, gtksourceview4, libcairo, pango, pycairo, pygobject, python"
TERMUX_PKG_BUILD_DEPENDS="gettext"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# The "byte-compile" build setting will go away in the next release
# It does not actually turn off byte compiling because Termux has recent Meson
# (https://gitlab.gnome.org/GNOME/meld/-/commit/361ac82ce94dd46d0eed0e9239c34a8e3d13cd2e)
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbyte-compile=false
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}

# It is really strange that this is necessary. The reason that meson is installing this
# into $TERMUX_PREFIX/local/lib/python3.12/dist-packages instead of $TERMUX_PREFIX/lib/python3.12/site-packages
# is not clear. Other distros do not seem to have this problem.
termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages"
	mv "$TERMUX_PREFIX/local/lib/python$TERMUX_PYTHON_VERSION/dist-packages/$TERMUX_PKG_NAME" \
		"$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages/"
	rm -rf "$TERMUX_PREFIX/local"
}
