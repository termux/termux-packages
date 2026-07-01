TERMUX_PKG_HOMEPAGE=https://github.com/termux/android-build-tools
TERMUX_PKG_DESCRIPTION="Android Asset Packaging Tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_TAG_VERSION=16.0.0
_TAG_REVISION=4
_ANDROID_BUILD_TOOLS_COMMIT=c4edf8539a34a8600538e6642c1ecb170452a79e
TERMUX_PKG_VERSION=${_TAG_VERSION}.${_TAG_REVISION}
TERMUX_PKG_SRCURL=git+https://github.com/termux/android-build-tools
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_DEPENDS="fmt, libc++, libexpat, libpng, libzopfli, zlib"
TERMUX_PKG_BUILD_DEPENDS="googletest, protobuf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_BUILD_TOOLS_DEV_MODE=ON
"

termux_step_post_get_source() {
	local _actual_commit
	_actual_commit=$(git rev-parse HEAD)
	if [[ "$_actual_commit" != "$_ANDROID_BUILD_TOOLS_COMMIT" ]]; then
		termux_error_exit "Expected android-build-tools commit $_ANDROID_BUILD_TOOLS_COMMIT, got $_actual_commit"
	fi
}

termux_step_pre_configure() {
	termux_setup_protobuf
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dprotobuf_generate_PROTOC_EXE=$(command -v protoc)"

	CFLAGS+=" -fPIC"
	CXXFLAGS+=" -fPIC"
	CPPFLAGS+=" -DNDEBUG -D__ANDROID_SDK_VERSION__=__ANDROID_API__"
	CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
}
