TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/cantor"
TERMUX_PKG_DESCRIPTION="KDE Frontend to Mathematical Software"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/cantor-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f0e9734410070b6ecb54dfe042862405b4ef01d65533c0be0386d13b9fdf7250
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="analitza, kf6-karchive, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-knewstuff, kf6-kparts, kf6-ktexteditor, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-syntax-highlighting, libc++, libspectre, libxml2, libxslt, luajit, poppler-qt, python, qalculate-gtk, qt6-qtbase, qt6-qtsvg, qt6-qttools, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="analitza, extra-cmake-modules, kf6-kdoctools, luajit, python"
TERMUX_PKG_RECOMMENDS="maxima, octave-x"
#qt6-qtwebengine is not supported for i686 architecture
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	local discount_src="${TERMUX_PKG_SRCDIR}/thirdparty/discount-2.2.6-patched"

	cd "${discount_src}"
	sh configure.sh

	gcc -I"${discount_src}" "${discount_src}/mktags.c" -o "${TERMUX_PKG_HOSTBUILD_DIR}/mktags"
	"${TERMUX_PKG_HOSTBUILD_DIR}/mktags" > "${TERMUX_PKG_HOSTBUILD_DIR}/blocktags"
}

termux_step_pre_configure() {
	rm -rf "$TERMUX_HOSTBUILD_MARKER"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"

		patch --silent -p1 -d "$TERMUX_PKG_SRCDIR" \
			< "$TERMUX_PKG_BUILDER_DIR/discount-crossbuild.diff"

		sed -i "s|SOURCE_SUBDIR cmake|SOURCE_SUBDIR cmake\n    PATCH_COMMAND \${CMAKE_COMMAND} -E copy_if_different $TERMUX_PKG_HOSTBUILD_DIR/blocktags <SOURCE_DIR>/blocktags|" \
			"$TERMUX_PKG_SRCDIR/thirdparty/CMakeLists.txt"
	fi
}
