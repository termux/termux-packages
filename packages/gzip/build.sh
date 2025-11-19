TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gzip/
TERMUX_PKG_DESCRIPTION="Standard GNU file compression utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.14
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gzip/gzip-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=01a7b881bd220bfdf615f97b8718f80bdfd3f6add385b993dcf6efd14e8c0ac6
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_GREP=grep"
TERMUX_PKG_GROUPS="base-devel"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = i686 ]; then
		# Avoid text relocations
		export DEFS="NO_ASM"
	fi
}
