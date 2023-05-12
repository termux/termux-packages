TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/make/
TERMUX_PKG_DESCRIPTION="Tool to control the generation of non-source files from source files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Update both make and make-guile to the same version in one PR.
TERMUX_PKG_VERSION=4.4.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/make/make-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3
TERMUX_PKG_DEPENDS="guile"
TERMUX_PKG_BREAKS="make-dev"
TERMUX_PKG_REPLACES="make-dev"
# Prevent linking against libelf:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_elf_elf_begin=no"
# Prevent linking against libiconv:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" am_cv_func_iconv=no"

# make-guile:
TERMUX_PKG_CONFLICTS="make"
TERMUX_PKG_PROVIDES="make"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-guile"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = arm ]; then
		# Fix issue with make on arm hanging at least under cmake:
		# https://github.com/termux/termux-packages/issues/2983
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_pselect=no"
	fi
}

termux_step_make() {
	# Allow to bootstrap make if building on device without make installed.
	if $TERMUX_ON_DEVICE_BUILD && [ -z "$(command -v make)" ]; then
		./build.sh
	else
		make -j $TERMUX_MAKE_PROCESSES
	fi
}

termux_step_make_install() {
	if $TERMUX_ON_DEVICE_BUILD && [ -z "$(command -v make)" ]; then
		./make -j 1 install
	else
		make -j 1 install
	fi
}
