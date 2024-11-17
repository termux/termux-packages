TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gzip/
TERMUX_PKG_DESCRIPTION="Standard GNU file compression utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.13
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gzip/gzip-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7454eb6935db17c6655576c2e1b0fabefd38b4d0936e0f87f48cd062ce91a057
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_GREP=grep"
TERMUX_PKG_GROUPS="base-devel"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = i686 ]; then
		# Avoid text relocations
		export DEFS="NO_ASM"
	fi
}
