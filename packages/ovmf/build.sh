TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="A modern, feature-rich, cross-platform firmware development environment for the UEFI and PI specifications from www.uefi.org."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="License.txt"
TERMUX_PKG_VERSION=()
TERMUX_PKG_VERSION+=(202005)
TERMUX_PKG_VERSION+=(1.0.7)
TERMUX_PKG_SRCURL=(https://github.com/tianocore/edk2/archive/edk2-stable${TERMUX_PKG_VERSION}.tar.gz
		   https://github.com/google/brotli/archive/v${TERMUX_PKG_VERSION[1]}.tar.gz
	   	   https://github.com/tianocore/edk2-platforms/archive/69009e5b91a70b6fc15cdf4bc410256052cb5752.tar.gz)
TERMUX_PKG_SHA256=(373c3eff3497316a48fcf4be8dcee227431cbce86dcd80a004950e992f0297e2
		   4c61bfb0faca87219ea587326c467b95acb25555b53d1a421ffa3c8a9296ee2c
		   7a226a6ea783b9b442c9269dca8ff76577afa62f6c00eaf5355779fca08ed4b1) 
TERMUX_PKG_DEPENDS="libuuid"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	export PATH=$TERMUX_PKG_SRCDIR/bin:$PATH
	mv brotli-${TERMUX_PKG_VERSION[1]}/* BaseTools/Source/C/BrotliCompress/brotli/
	export WORKSPACE=$TERMUX_PKG_SRCDIR
	export EDK_TOOLS_PATH=$TERMUX_PKG_SRCDIR/BaseTools
	export CONF_PATH=$TERMUX_PKG_SRCDIR/Conf
	make -C BaseTools
	. edksetup.sh BaseTools
	unset ARCH WORKSPACE
	export PACKAGES_PATH=$PWD:$PWD/edk2-platforms
	GCC5_AARCH64_PREFIX=aarch64-linux-android- build -a AARCH64 -p Platform/ARM/VExpressPkg/ArmVExpress-FVP-AArch64.dsc -t GCC5 -b RELEASE
	#sed "s|^TARGET[ ]*=.*|TARGET = RELEASE|; \
	#s|TOOL_CHAIN_TAG[ ]*=.*|TOOL_CHAIN_TAG = ${_toolchain_opt}|; \
	#s|MAX_CONCURRENT_THREAD_NUMBER[ ]*=.*|MAX_CONCURRENT_THREAD_NUMBER = $(nproc)|;" -i Conf/target.txt

}
