TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="A modern, feature-rich, cross-platform firmware development environment for the UEFI and PI specifications from www.uefi.org."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="License.txt"
TERMUX_PKG_VERSION=202005
TERMUX_PKG_SRCURL=https://github.com/tianocore/edk2/archive/edk2-stable$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=373c3eff3497316a48fcf4be8dcee227431cbce86dcd80a004950e992f0297e2
#TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	export PATH=$TERMUX_PKG_SRCDIR/bin:$PATH
	make -C BaseTools
	export EDK_TOOLS_PATH="${TERMUX_PKG_SRCDIR}"/edk2/BaseTools
	. edksetup.sh BaseTools
	unset ARCH WORKSPACE
	export PACKAGES_PATH=$PWD:$PWD/edk2-platforms
	sed "s|^TARGET[ ]*=.*|TARGET = RELEASE|; \
	s|TOOL_CHAIN_TAG[ ]*=.*|TOOL_CHAIN_TAG = ${_toolchain_opt}|; \
	s|MAX_CONCURRENT_THREAD_NUMBER[ ]*=.*|MAX_CONCURRENT_THREAD_NUMBER = $(nproc)|;" -i Conf/target.txt
}
