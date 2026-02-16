TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kcmutils"
TERMUX_PKG_DESCRIPTION="Utilities for interacting with KCModules"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kcmutils-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=54ecfedc0bc91ce95fa98b8b53e41d2993557e99a19b953395c2a5e5dc4210f8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kitemviews, kf6-kservice, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX/opt/kf6/cross" \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		-DCMAKE_MODULE_PATH="$TERMUX_PREFIX/share/ECM/modules" \
		-DKDE_INSTALL_LIBEXECDIR_KF=lib/libexec/kf6 \
		-DKDE_INSTALL_CMAKEPACKAGEDIR=lib/cmake \
		-DECM_DIR="$TERMUX_PREFIX/share/ECM/cmake" \
		-DTERMUX_PREFIX="$TERMUX_PREFIX" \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DTOOLS_ONLY=ON
	ninja \
		-j ${TERMUX_PKG_MAKE_PROCESSES} \
		install
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	cp -r "$TERMUX_PREFIX/lib/cmake/KF6KCMUtils" "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	sed -e 's|_IMPORT_PREFIX "'"$TERMUX_PREFIX"'"|_IMPORT_PREFIX "'"$TERMUX_PREFIX"'/opt/kf6/cross"|' -i "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/KF6KCMUtils/KF6KCMUtilsToolingTargets.cmake"
	sed -e 's|'"$TERMUX_PREFIX"'/lib/libexec/kf6/kcmdesktopfilegenerator|'"$TERMUX_PREFIX"'/opt/kf6/cross/lib/libexec/kf6/kcmdesktopfilegenerator|' -i "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/KF6KCMUtils/KF6KCMUtilsToolingTargets-release.cmake"
}
