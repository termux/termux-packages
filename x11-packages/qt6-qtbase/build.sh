TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="A cross-platform application and UI framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSES/GPL-3.0-only.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.8.2"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtbase-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=012043ce6d411e6e8a91fdc4e05e6bedcfa10fcb1347d3c33908f7fdd10dfe05
TERMUX_PKG_DEPENDS="brotli, double-conversion, freetype, glib, harfbuzz, libandroid-posix-semaphore, libandroid-shmem, libc++, libdrm, libice, libicu, libjpeg-turbo, libpng, libsm, libsqlite, libuuid, libx11, libxcb, libxi, libxkbcommon, libwayland, opengl, openssl, pcre2, vulkan-loader, xcb-util-cursor, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil, xcb-util-wm, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="binutils-cross, libwayland-protocols, vulkan-headers, vulkan-loader-generic"
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
TERMUX_PKG_RM_AFTER_INSTALL="
lib/objects-*
opt/qt6/cross/lib/objects-*
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
	cat $PWD/user_facing_tool_links.txt | xargs -P${TERMUX_PKG_MAKE_PROCESSES} -L1 ln -sv
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
	cat $PWD/user_facing_tool_links.txt | xargs -P${TERMUX_PKG_MAKE_PROCESSES} -L1 ln -sv
	find ${TERMUX_PREFIX}/lib/qt6 -type f -name target_qt.conf \
		-exec echo "{}" \; \
		-exec cat "{}" \;
}
