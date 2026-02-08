TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kwin-x11"
TERMUX_PKG_DESCRIPTION="An easy to use, but flexible, X Window Manager"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kwin-x11-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="89b9d41234f6f9bfe87fb472d77aefd1a8f9a447c4357169dcf810ad44e9b1d4"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="aurorae, breeze, kf6-kauth, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdeclarative, kdecoration, kf6-kglobalaccel, kglobalacceld, kf6-kguiaddons, kf6-ki18n, kf6-kidletime, kf6-kirigami, kf6-kitemmodels, kf6-knewstuff, kf6-knotifications, kf6-kpackage, kf6-kservice, kf6-ksvg, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, knighttime, libc++, libcanberra, libdisplay-info, libdrm, libepoxy, libplasma, libqaccessibilityclient-qt6, libwayland, libx11, libxcb, libxi, libxkbcommon, littlecms, mesa, plasma-activities, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtsensors, qt6-qtsvg, qt6-qttools, qt6-qtwayland, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, plasma-wayland-protocols, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DBUILD_QT6=ON
-DKWIN_BUILD_SCREENLOCKER=OFF
-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=OFF
"

termux_step_host_build() {
	# we'll only build qtwaylandscanner_kde here
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja \
		-S "${TERMUX_PKG_SRCDIR}/src/wayland/tools" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX/opt/kf6/cross \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		-DCMAKE_MODULE_PATH="$TERMUX_PREFIX/share/ECM/modules" \
		-DECM_DIR="$TERMUX_PREFIX/share/ECM/cmake" \
		-DTERMUX_PREFIX="$TERMUX_PREFIX" \
		-DCMAKE_INSTALL_LIBDIR=lib

	ninja -j ${TERMUX_PKG_MAKE_PROCESSES}

	mkdir -p "$TERMUX_PREFIX/opt/kf6/cross/bin"
	cp "$TERMUX_PKG_HOSTBUILD_DIR/qtwaylandscanner_kde" "$TERMUX_PREFIX/opt/kf6/cross/bin/"
}

termux_step_pre_configure() {
	rm -rf $TERMUX_HOSTBUILD_MARKER

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/lib/cmake"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQTWAYLANDSCANNER_KDE_EXECUTABLE=$TERMUX_PREFIX/opt/kf6/cross/bin/qtwaylandscanner_kde"
	fi

	LDFLAGS+=" -landroid-shmem"
}
