TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/breeze-icons'
TERMUX_PKG_DESCRIPTION='Breeze icon theme'
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/breeze-icons-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4239c49740b9e67096034224fa63d1a80c7e1b4b53ba5b381b2c2ef5b680930f
TERMUX_PKG_DEPENDS="qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), python-lxml, qt6-qtbase-cross-tools"
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
	pushd "$TERMUX_PKG_SRCDIR/tools"
	cp CMakeLists.txt CMakeLists.txt.bak
	patch -p1 -i "$TERMUX_PKG_BUILDER_DIR"/tools-CMakeLists.txt.diff

	mkdir -p build
	cmake -B build \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		.
	cmake --build build
	mv CMakeLists.txt.bak CMakeLists.txt
	popd

	cp "$TERMUX_PKG_SRCDIR"/tools/build/{generate-symbolic-dark,qrcAlias} "$TERMUX_PKG_HOSTBUILD_DIR/"
}

termux_step_pre_configure() {
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", kf6-breeze-icons-data"

	sed -e 's|$<TARGET_FILE:generate-symbolic-dark>|'"$TERMUX_PKG_HOSTBUILD_DIR"'/generate-symbolic-dark|' -i icons/CMakeLists.txt
	sed -e 's|$<TARGET_FILE:qrcAlias> -o|'"$TERMUX_PKG_HOSTBUILD_DIR"'/qrcAlias -o|' -i icons/CMakeLists.txt
}
