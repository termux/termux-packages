TERMUX_PKG_HOMEPAGE=https://avogadro.cc/
TERMUX_PKG_DESCRIPTION="Avogadro2 Library Package"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="https://github.com/OpenChemistry/avogadrolibs/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=feeebf815f39400c2a9bc8d0cf9466840f38c736c0aa88850b8657599b0cf216
TERMUX_PKG_DEPENDS="glew, glu, libarchive, libhdf5, libxml2, openbabel, opengl, qt6-qtbase, qt6-qtnetworkauth, qt6-qtsvg, rapidjson, readline, spglib, xz-utils"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtnetworkauth-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_PROVIDES="avogadro-libs, avogadrolibs"
TERMUX_PKG_RM_AFTER_INSTALL="
share/avogadro2/fragments/.gitignore
share/avogadro2/fragments/.pre-commit-config.yaml
share/doc/AvogadroLibs
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DQT_VERSION=6
-DUSE_LIBMSYM=OFF
-DUSE_MMTF=OFF
-DUSE_PLOTTER=OFF
-DUSE_LIBARCHIVE=ON
-DUSE_OPENGL=ON
-DUSE_SPGLIB=ON
"

termux_step_post_get_source() {
	# Remove the marker every time, as avogadrolibs is architecture-specific.
	rm -rf "$TERMUX_HOSTBUILD_MARKER"
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi
	export CXX="$TERMUX_HOST_LLVM_BASE_DIR/bin/clang++"
	cd "$TERMUX_PKG_SRCDIR/utilities/encodefile" || termux_error_exit "Failed to host-build encodefile."
	${CXX} -o encodefile encodefile.cxx
	mv ./encodefile "$TERMUX_PKG_HOSTBUILD_DIR/"
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
}
