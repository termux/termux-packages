TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kdoctools"
TERMUX_PKG_DESCRIPTION="Documentation generation from docbook"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kdoctools-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9e715bd56ef3001c7e6a514894277e5bc61e2576968be13f8b3c0a3fab536fc9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="docbook-xsl, kf6-karchive, libc++, libxml2, libxslt, perl, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-ki18n, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKF_IGNORE_PLATFORM_CHECK=ON
-DKF_SKIP_PO_PROCESSING=ON
-DINSTALL_INTERNAL_TOOLS=OFF
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_download_ubuntu_packages libxslt1-dev

	termux_setup_cmake
	termux_setup_ninja

	cmake -G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX/opt/kf6/cross" \
		-DCMAKE_PREFIX_PATH="$TERMUX_PREFIX/opt/qt6/cross/lib/cmake" \
		-DCMAKE_MODULE_PATH="$TERMUX_PREFIX/share/ECM/modules" \
		-DECM_DIR="$TERMUX_PREFIX/share/ECM/cmake" \
		-DLIBXSLT_LIBRARIES=/usr/lib/x86_64-linux-gnu/libxslt.so.1 \
		-DLIBXSLT_EXSLT_LIBRARY=/usr/lib/x86_64-linux-gnu/libexslt.so.0 \
		-DLIBXSLT_INCLUDE_DIR="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/include/x86_64-linux-gnu;$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/include" \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DINSTALL_INTERNAL_TOOLS=ON

	ninja -C "${TERMUX_PKG_HOSTBUILD_DIR}" docbookl10nhelper meinproc6

	ninja install
}

termux_step_pre_configure() {
	# Reset hostbuild marker
	rm -rf "$TERMUX_HOSTBUILD_MARKER"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DDOCBOOKL10NHELPER_EXECUTABLE=$TERMUX_PREFIX/opt/kf6/cross/bin/docbookl10nhelper
	-DMEINPROC6_EXECUTABLE=$TERMUX_PREFIX/opt/kf6/cross/bin/meinproc6
	"
}

termux_step_create_debscripts()  {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	set -e

	export PERL_MM_USE_DEFAULT=1

	echo "Sideloading Perl URI::Escape ..."
	cpan -Ti URI::Escape

	exit 0
	POSTINST_EOF
}
