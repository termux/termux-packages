TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="An advanced audio player"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6"
TERMUX_PKG_SRCURL="https://distfiles.audacious-media-player.org/audacious-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=03988a6a114e46f91dabcd4d0dae29fcad19f6029e3c28737938d1bd525979dd
TERMUX_PKG_DEPENDS="libarchive, libc++, qt6-qtbase, qt6-qttools, qt6-qtsvg, qt6-qtdeclarative, dbus-glib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools, qt6-qtsvg-cross-tools, qt6-qtdeclarative-cross-tools"
TERMUX_PKG_RECOMMENDS="audacious-plugins"
TERMUX_PKG_AUTO_UPDATE=true
# Enable Qt6, disable Qt5 and all GTK
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddbus=true
-Dqt=true
-Dqt5=false
-Dgtk=false
-Dgtk2=false
-Dlibarchive=true
-Dvalgrind=false
"

termux_step_configure() {
	termux_setup_meson

	# This is how to cross-compile Qt6 packages that use the Meson build system
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local TERMUX_MESON_QT_CROSSFILE="$TERMUX_PKG_TMPDIR/qt-cross-file.txt"
		cp -f "$TERMUX_MESON_CROSSFILE" "$TERMUX_MESON_QT_CROSSFILE"
		local qt6_tool
		for qt6_tool in bin/lrelease moc uic qmltyperegistrar qmlcachegen rcc; do
			sed -i "s|^\(\[binaries\]\)$|\1\n${TERMUX_PREFIX}/lib/qt6/${qt6_tool} = '${TERMUX_PREFIX}/opt/qt6/cross/lib/qt6/${qt6_tool}'|g" \
				"$TERMUX_MESON_QT_CROSSFILE"
		done
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --cross-file $TERMUX_MESON_QT_CROSSFILE"
	fi

	termux_step_configure_meson
}
