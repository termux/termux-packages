TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gzip/
TERMUX_PKG_DESCRIPTION="Standard GNU file compression utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.10
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gzip/gzip-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8425ccac99872d544d4310305f915f5ea81e04d0f437ef1a230dc9d1c819d7c0
TERMUX_PKG_ESSENTIAL=yes

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_GREP=grep"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = i686 ]; then
		# Avoid text relocations
		export DEFS="NO_ASM"
	fi
}
