TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Advanced configuration system (KDE)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.14.0"
TERMUX_PKG_REVISION=1
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kconfig-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a1b27e762b78fbc34124f35fd4125711f4036ae532c79d3cf3dc683289c1e765
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${_KF6_MINOR_VERSION}), qt6-qttools, qt6-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

# All dependencies using `kconfig_compiler_kf6` must have `kf6-kconfig-cross-tools` in TERMUX_PKG_BUILD_DEPENDS and have `-DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/` in TERMUX_PKG_EXTRA_CONFIGURE_ARGS.

termux_step_host_build() {
	# CMakeLists.txt
	cp "$TERMUX_PKG_SRCDIR/CMakeLists.txt" "$TERMUX_PKG_SRCDIR/CMakeLists.txt.bak"
	sed -i '/project(/q' "$TERMUX_PKG_SRCDIR/CMakeLists.txt" # keep project(KConfig VERSION ...) to denote the version
	cat >> "$TERMUX_PKG_SRCDIR/CMakeLists.txt" <<-'EOF'

	include(ECMSetupVersion)

	set(kconfig_version_header "${CMAKE_CURRENT_BINARY_DIR}/src/core/kconfig_version.h")
	ecm_setup_version(PROJECT VARIABLE_PREFIX KCONFIG
							VERSION_HEADER "${kconfig_version_header}")

	find_package(Qt6 REQUIRED COMPONENTS Core Widgets Xml)

	function(ecm_mark_nongui_executable)
	endfunction()

	add_link_options("-Wl,-rpath=${TERMUX_PREFIX}/opt/qt6/cross/lib")
	add_subdirectory(src/kconfig_compiler)
	EOF
	sed -e 's|#include "../core/kconfig_version.h"|#include "'"$TERMUX_PKG_HOSTBUILD_DIR"'/src/core/kconfig_version.h"|' -i "$TERMUX_PKG_SRCDIR/src/kconfig_compiler/kconfig_compiler.cpp"
	# build
	termux_setup_cmake
	termux_setup_ninja
	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX/opt/kf6/cross" \
		-DCMAKE_MODULE_PATH="$TERMUX_PREFIX/share/ECM/modules" \
		-DKDE_INSTALL_LIBEXECDIR_KF=lib/libexec/kf6 \
		-DKDE_INSTALL_CMAKEPACKAGEDIR=lib/cmake \
		-DTERMUX_PREFIX="$TERMUX_PREFIX"
	ninja \
		-j ${TERMUX_PKG_MAKE_PROCESSES} \
		install
	# recover the CMakeLists.txt
	mv "$TERMUX_PKG_SRCDIR/CMakeLists.txt.bak" "$TERMUX_PKG_SRCDIR/CMakeLists.txt"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	cp -r "$TERMUX_PREFIX/lib/cmake/KF6Config" "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	sed -e 's|_IMPORT_PREFIX "'"$TERMUX_PREFIX"'"|_IMPORT_PREFIX "'"$TERMUX_PREFIX"'/opt/kf6/cross"|' -i "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/KF6Config/KF6ConfigCompilerTargets.cmake"
	sed -e 's|'"$TERMUX_PREFIX"'/lib/libexec/kf6/kconfig_compiler_kf6|'"$TERMUX_PREFIX"'/opt/kf6/cross/lib/libexec/kf6/kconfig_compiler_kf6|' -i "$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/KF6Config/KF6ConfigCompilerTargets-release.cmake"
}
