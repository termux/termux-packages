TERMUX_PKG_HOMEPAGE=https://portal.hdfgroup.org/display/support
TERMUX_PKG_DESCRIPTION="Hierarchical Data Format 5 (HDF5)"
_HDF5_MAJOR=1
_HDF5_MINOR=10
_HDF5_PATCH=1
TERMUX_PKG_REVISION=1
TERMUX_PKG_VERSION=${_HDF5_MAJOR}.${_HDF5_MINOR}.${_HDF5_PATCH}
TERMUX_PKG_SHA256=9c5ce1e33d2463fb1a42dd04daacbc22104e57676e2204e3d66b1ef54b88ebf2
TERMUX_PKG_SRCURL=https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${_HDF5_MAJOR}.${_HDF5_MINOR}/hdf5-$TERMUX_PKG_VERSION/src/hdf5-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_DEPENDS="libzopfli"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-C$TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/TryRunResults_out.cmake "

termux_step_pre_configure () {
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/
	mkdir -p $TERMUX_PKG_BUILDDIR/shared/
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/shared/
}

termux_step_post_configure () {
	cp $TERMUX_PKG_BUILDER_DIR/$TERMUX_ARCH/{H5Tinit.c,H5lib_settings.c} $TERMUX_PKG_BUILDDIR/shared/
}

termux_step_post_make_install() {
	# Add a pkg-config file
	cat > "$PKG_CONFIG_LIBDIR/hdf5.pc" <<-HERE
		prefix=$TERMUX_PREFIX
		exec_prefix=\${prefix}
		libdir=\${exec_prefix}/lib
		includedir=\${exec_prefix}/include

		Name: hdf5
		Description: $TERMUX_PKG_DESCRIPTION
		Version: $TERMUX_PKG_VERSION
		Requires:
		Libs: -L\${libdir} -lhdf5
		Cflags: -I\${includedir}
		
	HERE
}
