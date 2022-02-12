TERMUX_PKG_HOMEPAGE=https://github.com/krrishnarraj/clpeak
TERMUX_PKG_DESCRIPTION="A tool which profiles OpenCL devices to find their peak capacities"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=https://github.com/krrishnarraj/clpeak.git
TERMUX_PKG_BUILD_DEPENDS="opencl-headers, opencl-clhpp"
TERMUX_PKG_DEPENDS="libc++, ocl-icd"

termux_step_post_get_source() {
	git fetch --unshallow
	git submodule deinit --force --all
	git submodule update --init --recursive
}
