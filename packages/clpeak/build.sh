TERMUX_PKG_HOMEPAGE=https://github.com/krrishnarraj/clpeak
TERMUX_PKG_DESCRIPTION="A tool which profiles OpenCL devices to find their peak capacities"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=1
_COMMIT=0777205be1d5681d5a76d46ec94588544e8462a5
TERMUX_PKG_SRCURL=https://github.com/krrishnarraj/clpeak.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_DEPENDS="opencl-headers"
TERMUX_PKG_DEPENDS="libc++, ocl-icd"

# clpeak 1.1.0 currently does not build with latest opencl hpp headers
# Use master branch until next release

termux_step_post_get_source() {
	git pull
	git reset --hard ${_COMMIT}
	git submodule foreach --recursive git reset --hard
}
