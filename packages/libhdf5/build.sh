TERMUX_PKG_HOMEPAGE=https://portal.hdfgroup.org/display/support
TERMUX_PKG_DESCRIPTION="Hierarchical Data Format 5 (HDF5)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.10.6
TERMUX_PKG_SRCURL=https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${TERMUX_PKG_VERSION:0:4}/hdf5-$TERMUX_PKG_VERSION/src/hdf5-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=09d6301901685201bb272a73e21c98f2bf7e044765107200b01089104a47c3bd
TERMUX_PKG_DEPENDS="libc++, libzopfli"
TERMUX_PKG_BREAKS="libhdf5-dev"
TERMUX_PKG_REPLACES="libhdf5-dev"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-C$TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/TryRunResults_out.cmake"

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
