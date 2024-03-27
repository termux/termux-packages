TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="A cross-platform application and UI framework"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="
LICENSES/AFL-2.1.txt
LICENSES/Apache-2.0.txt
LICENSES/BSD-3-Clause.txt
LICENSES/BSL-1.0.txt
LICENSES/CC0-1.0.txt
LICENSES/GFDL-1.3-no-invariants-only.txt
LICENSES/GPL-2.0-only.txt
LICENSES/GPL-2.0-or-later.txt
LICENSES/GPL-3.0-only.txt
LICENSES/LGPL-3.0-only.txt
LICENSES/LicenseRef-BSD-3-Clause-with-PCRE2-Binary-Like-Packages-Exception.txt
LICENSES/LicenseRef-Qt-Commercial.txt
LICENSES/LicenseRef-SHA1-Public-Domain.txt
LICENSES/MIT.txt
LICENSES/Qt-GPL-exception-1.0.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.1"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtbase-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=450c5b4677b2fe40ed07954d7f0f40690068e80a94c9df86c2c905ccd59d02f7
TERMUX_PKG_DEPENDS="brotli, double-conversion, freetype, glib, harfbuzz, libandroid-shmem, libandroid-sysv-semaphore, libc++, libdrm, libice, libicu, libjpeg-turbo, libpng, libsm, libsqlite, libuuid, libx11, libxcb, libxi, libxkbcommon, libwayland, opengl, openssl, pcre2, vulkan-loader, xcb-util-cursor, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil, xcb-util-wm, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, vulkan-headers, vulkan-loader-generic"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON
-DCMAKE_MESSAGE_LOG_LEVEL=STATUS
-DFEATURE_journald=OFF
-DFEATURE_no_direct_extern_access=ON
-DFEATURE_openssl_linked=ON
-DFEATURE_system_sqlite=ON
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
-DQT_FEATURE_freetype=ON
-DQT_FEATURE_gui=ON
-DQT_FEATURE_harfbuzz=ON
-DQT_FEATURE_widgets=ON
-DQT_FEATURE_zstd=ON
-DQT_HOST_PATH=${TERMUX_PREFIX}/opt/qt6/cross
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
		-j ${TERMUX_MAKE_PROCESSES} \
		install

	cat user_facing_tool_links.txt
	sed -e "s|^${TERMUX_PREFIX}/opt/qt6/cross|..|g" -i user_facing_tool_links.txt
	mkdir -p ${TERMUX_PREFIX}/opt/qt6/cross/bin
	cat user_facing_tool_links.txt | xargs -P${TERMUX_MAKE_PROCESSES} -L1 ln -sv
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	[[ "${TERMUX_ARCH}" == "arm" ]] && termux_setup_no_integrated_as

	LDFLAGS+=" -landroid-shmem -landroid-sysv-semaphore"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DCMAKE_C_COMPILER_AR=${TERMUX_STANDALONE_TOOLCHAIN}/bin/llvm-ar
	-DCMAKE_C_COMPILER_RANLIB=${TERMUX_STANDALONE_TOOLCHAIN}/bin/llvm-ranlib
	-DCMAKE_CXX_COMPILER_AR=${TERMUX_STANDALONE_TOOLCHAIN}/bin/llvm-ar
	-DCMAKE_CXX_COMPILER_RANLIB=${TERMUX_STANDALONE_TOOLCHAIN}/bin/llvm-ranlib
	"
}

termux_step_post_make_install() {
	find ${TERMUX_PKG_BUILDDIR} -type f -name user_facing_tool_links.txt
	cat ${TERMUX_PKG_BUILDDIR}/user_facing_tool_links.txt
	#cat ${TERMUX_PKG_BUILDDIR}/user_facing_tool_links.txt | xargs -P${TERMUX_MAKE_PROCESSES} -L1 ln -sv
	find ${TERMUX_PREFIX}/lib/qt6 -type f -name target_qt.conf
	find ${TERMUX_PREFIX}/lib/qt6 -type f -name target_qt.conf -exec cat "{}" \;
}
