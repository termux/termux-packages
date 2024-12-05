TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Breeze icon theme'
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.8.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/breeze-icons-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=75ee11fc441c27504e199e365693296edcd465f890db6aabcb0deca0ace22d3a
TERMUX_PKG_DEPENDS="qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), python-lxml, qt6-qtbase-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_TESTING=OFF
-DBINARY_ICONS_RESOURCE=ON
-DWITH_ICON_GENERATION=OFF
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_host_build() {
	termux_setup_cmake
	cd "$TERMUX_PKG_SRCDIR/src/tools"
	# patch CMakeLists.txt
	mv CMakeLists.txt CMakeLists.txt.bak
	cat > CMakeLists.txt <<-EOF
	cmake_minimum_required(VERSION 3.16)
	add_link_options("-Wl,-rpath=${TERMUX_PREFIX}/opt/qt6/cross/lib")

	find_package(Qt6 REQUIRED COMPONENTS Core Widgets Xml)

	function(ecm_mark_nongui_executable)
	endfunction()

	EOF
	cat CMakeLists.txt.bak >> CMakeLists.txt
	cat >> CMakeLists.txt <<-EOF

	install(TARGETS qrcAlias DESTINATION bin)
	install(TARGETS generate-symbolic-dark DESTINATION bin)
	EOF
	
	mkdir -p build
	cmake -B build \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		.
	cmake --build build
	mv CMakeLists.txt.bak CMakeLists.txt
}

termux_step_pre_configure() {
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", kf6-breeze-icons-data"

	sed -e 's|qrcAlias -o|'"$TERMUX_PKG_SRCDIR"'/src/tools/build/qrcAlias -o|' -i src/lib/CMakeLists.txt
}
