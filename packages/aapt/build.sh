TERMUX_PKG_HOMEPAGE=https://github.com/termux/android-build-tools
TERMUX_PKG_DESCRIPTION="Android Asset Packaging Tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=16.0.0.4
TERMUX_PKG_SRCURL=git+https://github.com/termux/android-build-tools
TERMUX_PKG_GIT_BRANCH=${TERMUX_PKG_VERSION}
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_DEPENDS="fmt, libc++, libexpat, libpng, libzopfli, zlib"
TERMUX_PKG_BUILD_DEPENDS="googletest, protobuf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_BUILD_TOOLS_DEV_MODE=ON
"

termux_step_pre_configure() {
	termux_setup_protobuf
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dprotobuf_generate_PROTOC_EXE=$(command -v protoc)"

	CFLAGS+=" -fPIC"
	CXXFLAGS+=" -fPIC"
	CPPFLAGS+=" -DNDEBUG -D__ANDROID_SDK_VERSION__=__ANDROID_API__"
	CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
}
