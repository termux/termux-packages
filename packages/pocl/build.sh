TERMUX_PKG_HOMEPAGE=http://portablecl.org/
TERMUX_PKG_DESCRIPTION="Portable Computing Language (pocl) is an open source implementation of the OpenCL standard which can be easily adapted for new targets and devices, both for homogeneous CPU and heterogeneous GPUs/accelerators."

#TERMUX_PKG_VERSION=0.14
#TERMUX_PKG_SRCURL="http://portablecl.org/downloads/pocl-$TERMUX_PKG_VERSION.tar.gz"
#TERMUX_PKG_SHA256=2127bf925a91fbbe3daf2f1bac0da5c8aceb16e2a9434977a3057eade974106a

TERMUX_PKG_VERSION=0.15pre
_COMMIT=bbdf13bc23241ef5a6e427edbb5eeab0702577fc
TERMUX_PKG_SHA256=b2eac65b8feb4d246b41df4e153bf08667cb5695f46b0fc1533a8e28bc022f87
TERMUX_PKG_SRCURL="https://github.com/pocl/pocl/archive/${_COMMIT}.zip"
TERMUX_PKG_FOLDERNAME=pocl-${_COMMIT}

TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_DEPENDS="libllvm,clang,libltdl,libtool,ncurses-dev,binutils,llvm,ndk-sysroot,hwloc"
#this is provided by libopencl-stub
TERMUX_PKG_RM_AFTER_INSTALL="include/CL/"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="\
		-DLLC_HOST_CPU=generic \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DCMAKE_SYSTEM_PROCESSOR=aarch64 \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_PROGRAM_PATH=$TERMUX_STANDALONE_TOOLCHAIN/bin;$TERMUX_TOPDIR/libllvm/host-build/bin \
		-DCMAKE_C_COMPILER=$CC \
		-DCMAKE_CXX_COMPILER=$CXX \
	"

}

