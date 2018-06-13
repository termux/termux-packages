TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gzip/
TERMUX_PKG_DESCRIPTION="Standard GNU file compression utilities"
TERMUX_PKG_VERSION=1.9
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=ae506144fc198bd8f81f1f4ad19ce63d5a2d65e42333255977cf1dcf1479089a
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gzip/gzip-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_GREP=grep"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = i686 ]; then
		# Avoid text relocations
		export DEFS="NO_ASM"
	fi
}
