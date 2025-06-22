TERMUX_PKG_HOMEPAGE=https://orca.gnome.org/
TERMUX_PKG_DESCRIPTION="A free, open source, flexible, and extensible screen reader"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.5"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/orca/${TERMUX_PKG_VERSION%.*}/orca-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=51529efdc07b15b9568eca0147f9a84ff915654046e2c021bfee6a04910dad66
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="at-spi2-core, glib, gst-python, gstreamer, gtk3, libwnck, pango, pyatspi, pygobject, python, python-pip, speechd"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_PYTHON_TARGET_DEPS="setproctitle"
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

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install $TERMUX_PKG_PYTHON_TARGET_DEPS
	EOF
}
