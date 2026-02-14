TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/syntax-highlighting"
TERMUX_PKG_DESCRIPTION="Syntax highlighting Engine for Structured Text and Code"
TERMUX_PKG_LICENSE="GPL-2.0-only, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/syntax-highlighting-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c95eac2babbea40be149e55939ffe47a14ffb0bc3d08103d3f32cb310364c38e
TERMUX_PKG_DEPENDS="libc++, qt6-qtdeclarative, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
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

	cmake -G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX/opt/kf6/cross \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		-DCMAKE_MODULE_PATH="$TERMUX_PREFIX/share/ECM/modules" \
		-DECM_DIR="$TERMUX_PREFIX/share/ECM/cmake" \
		-DTERMUX_PREFIX="$TERMUX_PREFIX" \
		-DCMAKE_INSTALL_LIBDIR=lib

	ninja -j ${TERMUX_PKG_MAKE_PROCESSES} install


	# Copy katehighlightingindexer to cross/bin
	mkdir -p "$TERMUX_PREFIX/opt/kf6/cross/bin"
	cp "$TERMUX_PKG_HOSTBUILD_DIR/bin/katehighlightingindexer" \
		"$TERMUX_PREFIX/opt/kf6/cross/bin/"
}

termux_step_pre_configure() {
	# Reset hostbuild marker
	rm -rf "$TERMUX_HOSTBUILD_MARKER"
	# Apply patch only for on-device builds
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		patch="$TERMUX_PKG_BUILDER_DIR/on-device-build.diff"
		echo "Applying patch: $(basename "$patch")"
		patch --silent -p1 -d "$TERMUX_PKG_SRCDIR" < "$patch"
		export PATH="$TERMUX_PKG_BUILDDIR/bin:$PATH"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKATEHIGHLIGHTINGINDEXER_EXECUTABLE=$TERMUX_PREFIX/opt/kf6/cross/bin/katehighlightingindexer"
	fi
}
