TERMUX_PKG_HOMEPAGE=https://sourceware.org/libffi/
TERMUX_PKG_DESCRIPTION="Library providing a portable, high level programming interface to various calling conventions"
_COMMIT=60e4250a77eb3fde500bfd68ec40519fe34b21bd
_DATE=20160904
TERMUX_PKG_VERSION=3.2.1.$_DATE
TERMUX_PKG_SRCURL=https://github.com/libffi/libffi/archive/${_COMMIT}.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-multi-os-directory"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-symvers=no"
TERMUX_PKG_RM_AFTER_INSTALL="lib/libffi-${TERMUX_PKG_VERSION}/include"
TERMUX_PKG_FOLDERNAME=libffi-$_COMMIT

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
}
