TERMUX_PKG_HOMEPAGE=https://savannah.gnu.org/projects/patch/
TERMUX_PKG_DESCRIPTION="GNU patch which applies diff files to create patched files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/patch/patch-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f87cee69eec2b4fcbf60a396b030ad6aa3415f192aa5f7ee84cad5e11f7f5ae3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-xattr ac_cv_path_ED=$TERMUX_PREFIX/bin/ed"
TERMUX_PKG_GROUPS="base-devel"

termux_step_pre_configure() {
	# https://android.googlesource.com/platform/bionic/+/master/docs/32-bit-abi.md#is-32_bit-on-lp32-y2038
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-year2038"
	fi
}
