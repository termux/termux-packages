TERMUX_PKG_HOMEPAGE=https://libcxx.llvm.org/
TERMUX_PKG_DESCRIPTION="C++ Standard Library"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
# Version should be equal to TERMUX_NDK_{VERSION_NUM,REVISION} in
# scripts/properties.sh
TERMUX_PKG_VERSION=27b
TERMUX_PKG_SRCURL=https://dl.google.com/android/repository/android-ndk-r${TERMUX_PKG_VERSION}-linux.zip
TERMUX_PKG_SHA256=33e16af1a6bbabe12cad54b2117085c07eab7e4fa67cdd831805f0e94fd826c1
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		termux_download_src_archive
		cd $TERMUX_PKG_TMPDIR
		termux_extract_src_archive
	else
		local lib_path="toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}"
		mkdir -p "$TERMUX_PKG_SRCDIR"/"$lib_path"
		cp "$NDK"/"$lib_path"/libc++_shared.so "$TERMUX_PKG_SRCDIR"/"$lib_path"
	fi
}

termux_step_post_make_install() {
	install -m700 -t "$TERMUX_PREFIX"/lib \
		toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/"${TERMUX_HOST_PLATFORM}"/libc++_shared.so
}
