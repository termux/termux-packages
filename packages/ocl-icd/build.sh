TERMUX_PKG_HOMEPAGE=https://github.com/OCL-dev/ocl-icd
TERMUX_PKG_DESCRIPTION="An OpenCL ICD loader"
TERMUX_PKG_VERSION=2.2.10
_COMMIT=v$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL="https://github.com/OCL-dev/ocl-icd/archive/${_COMMIT}.zip"
TERMUX_PKG_SHA256="5b9ea12934ab17889676634e62ccd00088ace79b61eca8e32d6a77521361c3dc"
TERMUX_PKG_FOLDERNAME=ocl-icd-$TERMUX_PKG_VERSION
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_KEEP_STATIC_LIBRARIES=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-official-khronos-headers"
#TERMUX_PKG_REPLACES="libopencl-stub"

termux_step_pre_configure() {       
	./bootstrap
	CFLAGS+=" -Dinline=static"
}

termux_step_post_make_install() {
	cp -r ../src/khronos-headers/* $TERMUX_PREFIX/include/
	cd $TERMUX_PREFIX/lib/
	ln -fs libOpenCL.so libOpenCL.so.1
}