TERMUX_PKG_HOMEPAGE=https://sourceware.org/libffi/
TERMUX_PKG_DESCRIPTION="Library providing a portable, high level programming interface to various calling conventions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.2
TERMUX_PKG_SRCURL=https://github.com/libffi/libffi/releases/download/v${TERMUX_PKG_VERSION}/libffi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=540fb721619a6aba3bdeef7d940d8e9e0e6d2c193595bc243241b77ff9e93620
TERMUX_PKG_BREAKS="libffi-dev"
TERMUX_PKG_REPLACES="libffi-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-multi-os-directory"
TERMUX_PKG_RM_AFTER_INSTALL="lib/libffi-${TERMUX_PKG_VERSION}/include"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}
termux_step_post_configure() {
	# work around since mmap can't be written and marked executable in android anymore from userspace
	echo "#define FFI_MMAP_EXEC_WRIT 1" >> fficonfig.h
}
