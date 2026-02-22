TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/akonadi"
TERMUX_PKG_DESCRIPTION="Cross-desktop storage service for PIM data providing concurrent access"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/akonadi-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="41ad06241b6278245bc3854a189e091dd113045d5a1449025d03a544de4c3bd3"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="kaccounts-integration, kf6-kcolorscheme, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kitemmodels, kf6-kwidgetsaddons, kf6-kxmlgui, kirigami-addons, libc++, libaccounts-qt, liblzma, libxml2, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kaccounts-integration, kf6-kconfigwidgets, kf6-kiconthemes, kf6-kitemmodels, kf6-kxmlgui, postgresql, qt6-qttools"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

local QT6_HOSTBUILD_COMPILER_ARGS="
	-L$TERMUX_PREFIX/opt/qt6/cross/lib
	-Wl,-rpath=$TERMUX_PREFIX/opt/qt6/cross/lib
	-lQt6Core
	-I$TERMUX_PREFIX/opt/qt6/cross/include/qt6/QtCore
	-I$TERMUX_PREFIX/opt/qt6/cross/include/qt6
	-I$TERMUX_PKG_SRCDIR/src/private/protocolgen
	"

	local PROTOCOLGEN_SOURCES="
	$TERMUX_PKG_SRCDIR/src/private/protocolgen/main.cpp
	$TERMUX_PKG_SRCDIR/src/private/protocolgen/cppgenerator.cpp
	$TERMUX_PKG_SRCDIR/src/private/protocolgen/cpphelper.cpp
	$TERMUX_PKG_SRCDIR/src/private/protocolgen/nodetree.cpp
	$TERMUX_PKG_SRCDIR/src/private/protocolgen/typehelper.cpp
	$TERMUX_PKG_SRCDIR/src/private/protocolgen/xmlparser.cpp
	"

	g++ $PROTOCOLGEN_SOURCES \
		$QT6_HOSTBUILD_COMPILER_ARGS \
		-o protocolgen
}

termux_step_pre_configure() {
	# Reset hostbuild marker
	rm -rf "$TERMUX_HOSTBUILD_MARKER"

	local patch="$TERMUX_PKG_BUILDER_DIR/protocolgen-path.diff"
	echo "Applying patch: $(basename "$patch")"
	patch --silent -p1 -d "$TERMUX_PKG_SRCDIR" < "$patch"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		# on-device build → target-built protocolgen
		sed -i "s|@PROTOCOLGEN@|\$<TARGET_FILE:protocolgen>|g" \
			src/private/CMakeLists.txt
	else
		# cross build → host-built protocolgen
		export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
		sed -i "s|@PROTOCOLGEN@|$(command -v protocolgen)|g" \
			src/private/CMakeLists.txt

		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	fi
}
