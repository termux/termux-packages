TERMUX_PKG_HOMEPAGE=https://github.com/protobuf-c/protobuf-c
TERMUX_PKG_DESCRIPTION="Protocol buffers C library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION="1.5.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/protobuf-c/protobuf-c/releases/download/v${TERMUX_PKG_VERSION}/protobuf-c-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, libc++, libprotobuf, protobuf"
TERMUX_PKG_BREAKS="libprotobuf-c-dev"
TERMUX_PKG_REPLACES="libprotobuf-c-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local a
	for a in CURRENT AGE; do
		local _LT_${a}=$(sed -En 's/^LIBPROTOBUF_C_'"${a}"'=([0-9]+).*/\1/p' \
				Makefile.am)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	termux_setup_protobuf
	export PROTOC=$(command -v protoc)

	CXXFLAGS+=" -std=c++17"
	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}
