TERMUX_PKG_VERSION=1.0
TERMUX_PKG_HOMEPAGE=https://github.com/krrishnarraj/clpeak
TERMUX_PKG_DESCRIPTION="A synthetic benchmarking tool to measure peak capabilities of a opencl device. This tool is intended toward developers to fine-tune opencl kernels for a particular device/class of device."
_COMMIT=8edab23fbc867adbada21378d65774c670c2aaf9                                      
TERMUX_PKG_SRCURL="https://github.com/krrishnarraj/clpeak/archive/${_COMMIT}.zip"                                       
TERMUX_PKG_FOLDERNAME=clpeak-${_COMMIT}
TERMUX_PKG_DEPENDS="ocl-icd"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {        
	cp clpeak $TERMUX_PREFIX/bin
}