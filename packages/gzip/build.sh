TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gzip/
TERMUX_PKG_DESCRIPTION="Standard GNU file compression utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.15
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/gzip/gzip-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9aa0cc780dec156b8282844833b342ab7cb08c25d2cd9a1869cdd0df31deff48
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_GREP=grep"
TERMUX_PKG_GROUPS="base-devel"

termux_step_pre_configure() {
	if [[ "$TERMUX_ARCH" == "i686" ]]; then
		# Avoid text relocations
		export DEFS="NO_ASM"
	fi
}
