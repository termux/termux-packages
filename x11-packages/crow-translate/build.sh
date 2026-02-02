TERMUX_PKG_HOMEPAGE=https://apps.kde.org/crowtranslate/
TERMUX_PKG_DESCRIPTION="Application that allows you to translate and speak text"
TERMUX_PKG_LICENSE="CC0-1.0, GPL-3.0-or-later, custom"
TERMUX_PKG_LICENSE_FILE="
LICENSES/CC0-1.0.txt
LICENSES/GPL-3.0-or-later.txt
LICENSES/CC-BY-SA-4.0.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/crow-translate/$TERMUX_PKG_VERSION/crow-translate-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=e24b8e78b0bffa5dd02875e25126c371967f53729102c784e4e02d165feb3753
TERMUX_PKG_DEPENDS="libc++, hicolor-icon-theme, kwayland, libx11, libxcb, onnxruntime, qt6-qtbase, qt6-qtmultimedia, qt6-qtscxml, qt6-qtspeech, tesseract"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, protobuf, qt6-qttools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_post_get_source() {
	# convert CRLF to LF like in libpluto package
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		DOS2UNIX="$TERMUX_PKG_TMPDIR/dos2unix"
		(. "$TERMUX_SCRIPTDIR/packages/dos2unix/build.sh"; TERMUX_PKG_SRCDIR="$DOS2UNIX" termux_step_get_source)
		pushd "$DOS2UNIX"
		make dos2unix
		popd # DOS2UNIX
		export PATH="$DOS2UNIX:$PATH"
	fi

	find "$TERMUX_PKG_SRCDIR" -type f -print0 | xargs -0 dos2unix
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja \
		"$TERMUX_PKG_SRCDIR/src/3rdparty/espeak-ng" \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PKG_HOSTBUILD_DIR/espeak-ng_installation"
	ninja
	ninja install
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local patch="$TERMUX_PKG_BUILDER_DIR/espeakng-hostbuild.diff"
		echo "Applying patch: $patch"
		sed -e "s%\@ESPEAKNG_DIR\@%${TERMUX_PKG_HOSTBUILD_DIR}/espeak-ng_installation/bin%g" \
			"$patch" | patch --silent -p1
	fi
}
