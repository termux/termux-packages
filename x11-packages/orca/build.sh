TERMUX_PKG_HOMEPAGE=https://orca.gnome.org/
TERMUX_PKG_DESCRIPTION="A free, open source, flexible, and extensible screen reader"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/orca/${TERMUX_PKG_VERSION%.*}/orca-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=53df41558319e97c1e84ad604989957a02b5d0ff531419190f0587ea6b256034
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="at-spi2-core, glib, gsettings-desktop-schemas, gst-python, gstreamer, gtk3, libwnck, pango, pyatspi, pygobject, python, python-pip, speechd, xorg-xkbcomp"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_PYTHON_TARGET_DEPS="dasbus, setproctitle"
TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cross-file $TERMUX_MESON_WHEEL_CROSSFILE
"

termux_step_pre_configure() {
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

termux_step_configure() {
	termux_setup_meson

	cp -f $TERMUX_MESON_CROSSFILE $TERMUX_MESON_WHEEL_CROSSFILE
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed -i 's|^\(\[binaries\]\)$|\1\nitstool = '\'$ITSTOOL\''|g' \
			$TERMUX_MESON_WHEEL_CROSSFILE
	fi

	termux_step_configure_meson
}
