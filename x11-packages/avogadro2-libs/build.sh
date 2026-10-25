TERMUX_PKG_HOMEPAGE=https://avogadro.cc/
TERMUX_PKG_DESCRIPTION="Avogadro2 Library Package"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="https://github.com/OpenChemistry/avogadrolibs/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=feeebf815f39400c2a9bc8d0cf9466840f38c736c0aa88850b8657599b0cf216
TERMUX_PKG_DEPENDS="eigen, glew, glu, libhdf5, libxml2, openbabel, opengl, qt6-qtbase, qt6-qtnetworkauth, qt6-qtsvg, rapidjson, readline, spglib, xz-utils"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtnetworkauth-cross-tools"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_PROVIDES="avogadro-libs, avogadrolibs"
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
-DQT_VERSION=6
-DUSE_LIBARCHIVE=OFF
-DUSE_LIBMSYM=OFF
-DUSE_MMTF=OFF
-DUSE_OPENGL=OFF
-DUSE_PLOTTER=OFF
-DUSE_SPGLIB=OFF
-DUSE_SYSTEM_EIGEN=ON
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQT_VERSION=6
-DUSE_LIBARCHIVE=OFF
-DUSE_LIBMSYM=OFF
-DUSE_MMTF=OFF
-DUSE_PLOTTER=OFF
-DUSE_OPENGL=ON
-DUSE_SPGLIB=ON
-DUSE_SYSTEM_EIGEN=ON
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	local eigen_version eigen_srcurl eigen_sha256
	eigen_version="$(. "${TERMUX_SCRIPTDIR}/packages/eigen/build.sh"; echo "${TERMUX_PKG_VERSION}")"
	eigen_srcurl="$(. "${TERMUX_SCRIPTDIR}/packages/eigen/build.sh"; echo "${TERMUX_PKG_SRCURL}")"
	eigen_sha256="$(. "${TERMUX_SCRIPTDIR}/packages/eigen/build.sh"; echo "${TERMUX_PKG_SHA256}")"

	termux_download \
		"$eigen_srcurl" \
		"${TERMUX_PKG_CACHEDIR}/$(basename "${eigen_srcurl}")" \
		"$eigen_sha256"

	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${eigen_srcurl}")"

	termux_setup_cmake
	termux_setup_ninja

	local -a ubuntu_packages=(
		"libqt6concurrent6"
		"libqt6core6t64"
		"libqt6network6"
		"libqt6opengl6"
		"libqt6openglwidgets6"
		"libqt6widgets6"
		"qmake6"
		"qt6-base-dev"
		"qt6-base-dev-tools"
		"qt6-networkauth-dev"
		"qt6-svg-dev"
	)
	# Grab required host libraries
	termux_download_ubuntu_packages "${ubuntu_packages[@]}"

	# Perform a host-build of eigen (5.x) for avogadro-libs
	# Only eigen3 is available from the Ubuntu repos.
	cmake -G Ninja \
		-S "eigen-${eigen_version}" \
		-B "${TERMUX_PKG_HOSTBUILD_DIR}/eigen" \
		-DCMAKE_BUILD_TYPE=Release
	ninja -C "${TERMUX_PKG_HOSTBUILD_DIR}/eigen" \
		-j "$TERMUX_PKG_MAKE_PROCESSES"

	# Perform a host-build of avogadro-libs
	cmake -G Ninja \
	-S "${TERMUX_PKG_SRCDIR}" \
	-B "${TERMUX_PKG_HOSTBUILD_DIR}" \
	-DQt6_DIR="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr/lib/x86_64-linux-gnu/cmake/Qt6" \
	-DQT_MOC_EXECUTABLE="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr/lib/qt6/libexec/moc" \
	-DQT_UIC_EXECUTABLE="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr/lib/qt6/libexec/uic" \
	-DQt6Gui_FOUND=ON \
	-DQt6OpenGLWidgets_FOUND=ON \
	-DQt6OpenGL_FOUND=ON \
	-DQt6Widgets_FOUND=ON \
	-DQt6_FOUND=ON \
	${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}

	ninja -j "$TERMUX_PKG_MAKE_PROCESSES"

	# We only need encodefile to use it later for the actual build.
	cp -vf ./build/bin/encodefile "$TERMUX_PKG_HOSTBUILD_DIR/"

	make distclean
	rm -rf build/
}
