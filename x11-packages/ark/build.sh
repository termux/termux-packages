TERMUX_PKG_HOMEPAGE="https://apps.kde.org/ark"
TERMUX_PKG_DESCRIPTION="KDE Archiving Tool"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/ark-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=abd7350914c65a763cac513cd679f635555b618c1df183b331134f7b3229a478
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="7zip, arj, kf6-breeze-icons, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kio, kf6-kjobwidgets, kf6-kparts, kf6-kpty, kf6-kservice, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, libarchive, libc++, libzip, lrzip, lzop, qt6-qtbase, unrar, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi

	# check libarchive at build-time, not runtime, because checking it at runtime
	# completely ruins the performance of right-clicking
	# in dolphin file browser when ark and dolphin are both installed at the same time
	local libarchive_has_lzo=false
	local libarchive_build_sh="$TERMUX_SCRIPTDIR/packages/libarchive/build.sh"
	local libarchive_has_lzo_str
	for libarchive_has_lzo_str in ENABLE_LZO={1,ON,YES,TRUE,Y} with-lzo; do
		if grep -q "$libarchive_has_lzo_str" "$libarchive_build_sh"; then
			libarchive_has_lzo=true
		fi
	done

	local patch="$TERMUX_PKG_BUILDER_DIR/check-libarchive-at-build-time.diff"
	echo "Applying patch: $patch"
	sed -e "s%\@LIBARCHIVE_HAS_LZO\@%${libarchive_has_lzo}%g" \
		"$patch" | patch --silent -p1 -d "${TERMUX_PKG_SRCDIR}"
}
