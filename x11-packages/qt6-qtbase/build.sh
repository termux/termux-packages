TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="A cross-platform application and UI framework"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_LICENSE_FILE="LICENSES/GPL-3.0-only.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.10.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtbase-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=5a6226f7e23db51fdc3223121eba53f3f5447cf0cc4d6cb82a3a2df7a65d265d
TERMUX_PKG_DEPENDS="brotli, double-conversion, freetype, glib, harfbuzz, libandroid-posix-semaphore, libandroid-shmem, libc++, libdrm, libice, libicu, libjpeg-turbo, libpng, libsm, libsqlite, libuuid, libx11, libxcb, libxi, libxkbcommon, libwayland, opengl, openssl, pcre2, vulkan-loader, xcb-util-cursor, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil, xcb-util-wm, zlib, zstd"
# gtk3 dependency is a run-time dependency only for the gtk platformtheme subpackage
TERMUX_PKG_BUILD_DEPENDS="binutils-cross, gdk-pixbuf, gtk3, libwayland-protocols, pango, vulkan-headers, vulkan-loader-generic"
# qt6-qtbase now contains include/qt6/QtWaylandClient/QWaylandClientExtension instead of qt6-qtwayland
TERMUX_PKG_CONFLICTS="qt6-qtwayland (<< 6.10.0)"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON
-DCMAKE_MESSAGE_LOG_LEVEL=STATUS
-DCMAKE_SYSTEM_NAME=Linux
-DFEATURE_journald=OFF
-DFEATURE_no_direct_extern_access=ON
-DFEATURE_openssl_linked=ON
-DFEATURE_system_sqlite=ON
-DFEATURE_forkfd_pidfd=OFF
-DINSTALL_ARCHDATADIR=lib/qt6
-DINSTALL_BINDIR=lib/qt6/bin
-DINSTALL_DATADIR=share/qt6
-DINSTALL_DOCDIR=share/doc/qt6
-DINSTALL_EXAMPLESDIR=share/doc/qt6/examples
-DINSTALL_INCLUDEDIR=include/qt6
-DINSTALL_LIBEXECDIR=lib/qt6
-DINSTALL_MKSPECSDIR=lib/qt6/mkspecs
-DINSTALL_PUBLICBINDIR=${TERMUX_PREFIX}/bin
-DQT_ALLOW_SYMLINK_IN_PATHS=OFF
-DQT_BUILD_TOOLS_BY_DEFAULT=ON
-DQT_FEATURE_freetype=ON
-DQT_FEATURE_gui=ON
-DQT_FEATURE_harfbuzz=ON
-DQT_FEATURE_ipc_posix=ON
-DQT_FEATURE_widgets=ON
-DQT_FEATURE_zstd=ON
-DQT_FORCE_BUILD_TOOLS=ON
-DQT_HOST_PATH=${TERMUX_PREFIX}/opt/qt6/cross
"
TERMUX_PKG_NO_SHEBANG_FIX_FILES="
lib/qt6/bin/qmake
lib/qt6/bin/qmake6
lib/qt6/bin/qt-cmake
lib/qt6/bin/qt-cmake-create
lib/qt6/bin/qt-configure-module
lib/qt6/bin/qtpaths
lib/qt6/bin/qtpaths6
opt/qt6/cross/lib/cmake/Qt6/libexec/qt-internal-ninja.in
opt/qt6/cross/lib/cmake/Qt6/libexec/qt-internal-strip.in
opt/qt6/cross/lib/qt6/bin/qt-cmake
opt/qt6/cross/lib/qt6/bin/qt-cmake-create
opt/qt6/cross/lib/qt6/bin/qt-configure-module
opt/qt6/cross/lib/qt6/mkspecs/features/data/mac/objc_namespace.sh
opt/qt6/cross/lib/qt6/mkspecs/features/uikit/device_destinations.sh
opt/qt6/cross/lib/qt6/mkspecs/features/uikit/devices.py
opt/qt6/cross/lib/qt6/qt-cmake-private
opt/qt6/cross/lib/qt6/qt-cmake-standalone-test
opt/qt6/cross/lib/qt6/qt-internal-configure-examples
opt/qt6/cross/lib/qt6/qt-internal-configure-tests
opt/qt6/cross/lib/qt6/qt-testrunner.py
opt/qt6/cross/lib/qt6/sanitizer-testrunner.py
"

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-S ${TERMUX_PKG_SRCDIR} \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_INSTALL_PREFIX=${TERMUX_PREFIX}/opt/qt6/cross \
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
		-DCMAKE_MESSAGE_LOG_LEVEL=STATUS \
		-DFEATURE_journald=OFF \
		-DFEATURE_openssl_linked=ON \
		-DFEATURE_system_sqlite=ON \
		-DINSTALL_ARCHDATADIR=lib/qt6 \
		-DINSTALL_BINDIR=lib/qt6/bin \
		-DINSTALL_DATADIR=share/qt6 \
		-DINSTALL_DOCDIR=share/doc/qt6 \
		-DINSTALL_EXAMPLESDIR=share/doc/qt6/examples \
		-DINSTALL_INCLUDEDIR=include/qt6 \
		-DINSTALL_LIBEXECDIR=lib/qt6 \
		-DINSTALL_MKSPECSDIR=lib/qt6/mkspecs \
		-DINSTALL_PUBLICBINDIR=${TERMUX_PREFIX}/opt/qt6/cross/bin \
		-DQT_ALLOW_SYMLINK_IN_PATHS=OFF \
		-DQT_FEATURE_freetype=ON \
		-DQT_FEATURE_gui=ON \
		-DQT_FEATURE_harfbuzz=ON \
		-DQT_FEATURE_widgets=ON \
		-DQT_FEATURE_zstd=OFF
	ninja \
		-j ${TERMUX_PKG_MAKE_PROCESSES} \
		install

	mkdir -p ${TERMUX_PREFIX}/opt/qt6/cross/bin
	find "$PWD" -type f -name user_facing_tool_links.txt \
		-exec echo "{}" \; \
		-exec cat "{}" \; \
		-exec sed -e "s|^${TERMUX_PREFIX}/opt/qt6/cross|..|g" -i "{}" \;

	while read -r target link; do
		ln -sv "$target" "$TERMUX_PREFIX/opt/qt6/cross/$link"
	done < "$PWD/user_facing_tool_links.txt"

	find ${TERMUX_PREFIX}/opt/qt6/cross -type f -name target_qt.conf \
		-exec echo "{}" \; \
		-exec cat "{}" \;
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	LDFLAGS+=" -landroid-posix-semaphore -landroid-shmem"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DCMAKE_C_COMPILER_AR=$(command -v llvm-ar)
	-DCMAKE_C_COMPILER_RANLIB=$(command -v llvm-ranlib)
	-DCMAKE_CXX_COMPILER_AR=$(command -v llvm-ar)
	-DCMAKE_CXX_COMPILER_RANLIB=$(command -v llvm-ranlib)
	"
}

termux_step_post_make_install() {
	find ${TERMUX_PKG_BUILDDIR} -type f -name user_facing_tool_links.txt \
		-exec echo "{}" \; \
		-exec cat "{}" \;

	while read -r target link; do
		ln -sv "$target" "$TERMUX_PREFIX/$link"
	done < "$PWD/user_facing_tool_links.txt"

	find ${TERMUX_PREFIX}/lib/qt6 -type f -name target_qt.conf \
		-exec echo "{}" \; \
		-exec cat "{}" \;
}
