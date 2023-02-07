TERMUX_PKG_HOMEPAGE=https://github.com/protocolbuffers/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# Please as well update SHA256 checksum for $_PROTOBUF_ZIP in
#   $TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_protobuf.sh
# when bumping version.
TERMUX_PKG_VERSION=2:21.12
TERMUX_PKG_SRCURL=https://github.com/protocolbuffers/protobuf/archive/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=22fdaf641b31655d4b2297f9981fa5203b2866f8332d3c6333f6b0107bb320de
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="libprotobuf-dev"
TERMUX_PKG_REPLACES="libprotobuf-dev"
TERMUX_PKG_FORCE_CMAKE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-static
--with-protoc=protoc
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=32

	local e=$(sed -En 's/^PROTOBUF_VERSION\s*=\s*"?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
				src/Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	mv CMakeLists.txt{,.unused}
}

termux_step_pre_configure() {
	termux_setup_protobuf

	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
