TERMUX_PKG_HOMEPAGE=https://avogadro.cc/
TERMUX_PKG_DESCRIPTION="Avogadro2 Library Package"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="https://github.com/OpenChemistry/avogadrolibs/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=feeebf815f39400c2a9bc8d0cf9466840f38c736c0aa88850b8657599b0cf216
TERMUX_PKG_DEPENDS="qt6-qtbase, qt6-qtsvg, qt6-qtnetworkauth, opengl, glu, libxml2, xz-utils, readline, rapidjson, glew, eigen, openbabel, spglib, libhdf5"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtnetworkauth-cross-tools"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_PROVIDES="avogadro-libs, avogadrolibs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_OPENGL=ON
-DUSE_LIBARCHIVE=OFF
-DUSE_SPGLIB=ON
-DUSE_MMTF=OFF
-DUSE_PLOTTER=OFF
-DUSE_LIBMSYM=OFF
"

termux_step_host_build() {
	termux_setup_cmake

	mkdir -p $TERMUX_PKG_SRCDIR/build
	cd $TERMUX_PKG_SRCDIR/build
	cmake .. $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make

	# We only need encodefile to use it later for the actual build.
	cp -vf ./build/bin/encodefile "$TERMUX_PKG_HOSTBUILD_DIR/"

	make distclean
	rm -rf build/
}
