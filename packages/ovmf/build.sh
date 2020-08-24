TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="A modern, feature-rich, cross-platform firmware development environment for the UEFI and PI specifications from www.uefi.org."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="License.txt"
TERMUX_PKG_VERSION=()
TERMUX_PKG_VERSION+=(202005)
TERMUX_PKG_VERSION+=(1.0.7)
TERMUX_PKG_SRCURL=(https://github.com/tianocore/edk2/archive/edk2-stable${TERMUX_PKG_VERSION}.tar.gz
		   https://github.com/google/brotli/archive/v${TERMUX_PKG_VERSION[1]}.tar.gz
	   	   https://github.com/tianocore/edk2-platforms.git)
TERMUX_PKG_SHA256=(373c3eff3497316a48fcf4be8dcee227431cbce86dcd80a004950e992f0297e2
		   4c61bfb0faca87219ea587326c467b95acb25555b53d1a421ffa3c8a9296ee2c
		   98ef5ceb62832d1665004c7c8ac47c1519b6d4f52080e20e2af8ce2f5d9f508b) 
TERMUX_PKG_DEPENDS="libuuid"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	export PATH=$TERMUX_PKG_SRCDIR/bin:$PATH
	mv brotli-${TERMUX_PKG_VERSION[1]}/* BaseTools/Source/C/BrotliCompress/brotli/
	make -C BaseTools
	export EDK_TOOLS_PATH="${TERMUX_PKG_SRCDIR}"/edk2/BaseTools
	. edksetup.sh BaseTools
	unset ARCH WORKSPACE
	export PACKAGES_PATH=$PWD:$PWD/edk2-platforms
	GCC5_AARCH64_PREFIX=aarch64-linux-android- build -a AARCH64 -p Platform/ARM/VExpressPkg/ArmVExpress-FVP-AArch64.dsc -t GCC5 -b RELEASE
	#sed "s|^TARGET[ ]*=.*|TARGET = RELEASE|; \
	#s|TOOL_CHAIN_TAG[ ]*=.*|TOOL_CHAIN_TAG = ${_toolchain_opt}|; \
	#s|MAX_CONCURRENT_THREAD_NUMBER[ ]*=.*|MAX_CONCURRENT_THREAD_NUMBER = $(nproc)|;" -i Conf/target.txt

}
