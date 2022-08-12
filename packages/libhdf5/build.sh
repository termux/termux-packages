TERMUX_PKG_HOMEPAGE=https://portal.hdfgroup.org/display/support
TERMUX_PKG_DESCRIPTION="Hierarchical Data Format 5 (HDF5)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${TERMUX_PKG_VERSION:0:4}/hdf5-$TERMUX_PKG_VERSION/src/hdf5-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=97906268640a6e9ce0cde703d5a71c9ac3092eded729591279bf2e3ca9765f61
TERMUX_PKG_DEPENDS="libc++, libzopfli, zlib"
TERMUX_PKG_BREAKS="libhdf5-dev"
TERMUX_PKG_REPLACES="libhdf5-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHDF5_ENABLE_Z_LIB_SUPPORT=on
-C$TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/TryRunResults_out.cmake
"

termux_step_pre_configure () {
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/
	mkdir -p $TERMUX_PKG_BUILDDIR/shared/
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/shared/
	touch $TERMUX_PKG_BUILDDIR/gen_SRCS.stamp1 $TERMUX_PKG_BUILDDIR/gen_SRCS.stamp2
	touch $TERMUX_PKG_BUILDDIR/shared/shared_gen_SRCS.stamp1 $TERMUX_PKG_BUILDDIR/shared/shared_gen_SRCS.stamp2
}

termux_step_post_configure () {
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/shared/
}
