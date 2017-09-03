TERMUX_PKG_VERSION=2.2.17.08.25
TERMUX_PKG_HOMEPAGE=https://github.com/Oblomov/clinfo
TERMUX_PKG_DESCRIPTION="An application that enumerates the properties of OpenCL platforms and devices"
_COMMIT=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL="https://github.com/Oblomov/clinfo/archive/${_COMMIT}.zip"                                       
TERMUX_PKG_FOLDERNAME=clinfo-${_COMMIT}
TERMUX_PKG_DEPENDS="ocl-icd"
TERMUX_PKG_BUILD_IN_SRC=yes


termux_step_pre_configure() 
{	
	LDFLAGS+=" -ldl"
}


termux_step_make_install () {
	cp clinfo $TERMUX_PREFIX/bin
}
