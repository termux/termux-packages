TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Classes for QML and JavaScript languages"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.8.2"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtdeclarative-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=144d876adc8bb55909735143e678d1e24eadcd0a380a0186792d88b731346d56
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase (>= ${TERMUX_PKG_VERSION})"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtlanguageserver (>= ${TERMUX_PKG_VERSION}), qt6-shadertools (>= ${TERMUX_PKG_VERSION})"
TERMUX_PKG_RECOMMENDS="qt6-qtlanguageserver"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_MESSAGE_LOG_LEVEL=STATUS
-DCMAKE_SYSTEM_NAME=Linux
-DINSTALL_PUBLICBINDIR=${TERMUX_PREFIX}/bin
-DQT_BUILD_TOOLS_BY_DEFAULT=ON
-DQT_FORCE_BUILD_TOOLS=ON
-DQT_HOST_PATH=${TERMUX_PREFIX}/opt/qt6/cross
"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/objects-*
lib/qt6/qml/Qt/test/controls/objects-*
opt/qt6/cross/lib/objects-*
opt/qt6/cross/lib/qt6/qml/Qt/test/controls/objects-*
"

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-S ${TERMUX_PKG_SRCDIR} \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_INSTALL_PREFIX=${TERMUX_PREFIX}/opt/qt6/cross \
		-DCMAKE_MESSAGE_LOG_LEVEL=STATUS \
		-DINSTALL_PUBLICBINDIR=${TERMUX_PREFIX}/opt/qt6/cross/bin
	ninja \
		-j ${TERMUX_PKG_MAKE_PROCESSES} \
		install

	mkdir -p ${TERMUX_PREFIX}/opt/qt6/cross/bin
	find "$PWD" -type f -name user_facing_tool_links.txt \
		-exec echo "{}" \; \
		-exec cat "{}" \; \
		-exec sed -e "s|^${TERMUX_PREFIX}/opt/qt6/cross|..|g" -i "{}" \;
	cat $PWD/user_facing_tool_links.txt | xargs -P${TERMUX_PKG_MAKE_PROCESSES} -L1 ln -sv
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	# The -flto flag seems to be used only when compiling and not linking,
	# which breaks the NDK clang fallback to emulated TLS - see
	# https://github.com/termux/termux-packages/issues/21733:
	LDFLAGS+=" -flto"
}

termux_step_make_install() {
	cmake \
		--install "${TERMUX_PKG_BUILDDIR}" \
		--prefix "${TERMUX_PREFIX}" \
		--verbose
}

termux_step_post_make_install() {
	find ${TERMUX_PKG_BUILDDIR} -type f -name user_facing_tool_links.txt \
		-exec echo "{}" \; \
		-exec cat "{}" \;
	cat $PWD/user_facing_tool_links.txt | xargs -P${TERMUX_PKG_MAKE_PROCESSES} -L1 ln -sv
}
