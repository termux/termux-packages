TERMUX_PKG_HOMEPAGE=https://sourceware.org/libffi/
TERMUX_PKG_DESCRIPTION="Library providing a portable, high level programming interface to various calling conventions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libffi/libffi/releases/download/v${TERMUX_PKG_VERSION}/libffi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0dea9df23c863a7a50e825440f3ebffabd65df1497108e5d437747843895a4e
TERMUX_PKG_BREAKS="libffi-dev"
TERMUX_PKG_REPLACES="libffi-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-multi-os-directory"
TERMUX_PKG_RM_AFTER_INSTALL="lib/libffi-${TERMUX_PKG_VERSION}/include"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=8

	local e=$(sed -En 's/^[^0-9#]*([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			libtool-version)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_post_configure() {
	# work around since mmap can't be written and marked executable in android anymore from userspace
	echo "#define FFI_MMAP_EXEC_WRIT 1" >> fficonfig.h
}
