TERMUX_PKG_HOMEPAGE="https://gitlab.com/ixion/ixion/blob/master/README.md"
TERMUX_PKG_DESCRIPTION="A general purpose formula parser & interpreter"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://gitlab.com/ixion/ixion/-/archive/${TERMUX_PKG_VERSION}/ixion-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4a6c2c480ad40b706ecf459dfca03f39351e12b48911c7c4803b75c823a1bcb1
TERMUX_PKG_DEPENDS="boost, libc++"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, mdds, libspdlog"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-python
--with-boost=$TERMUX_PREFIX
boost_cv_lib_system=yes
"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh

	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libixion-0.20.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
