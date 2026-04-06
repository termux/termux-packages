TERMUX_PKG_HOMEPAGE=https://github.com/saghul/txiki.js
TERMUX_PKG_DESCRIPTION="A small and powerful JavaScript runtime"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:26.4.0"
TERMUX_PKG_SRCURL=git+https://github.com/saghul/txiki.js
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, libcurl, libffi"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_NATIVE=OFF
-DUSE_EXTERNAL_FFI=ON
-DFFI_INCLUDE_DIR=$TERMUX_PREFIX/include
-DFFI_LIB=$TERMUX_PREFIX/lib/libffi.so
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
	cp -r "$TERMUX_PKG_SRCDIR" "$TERMUX_PKG_HOSTBUILD_DIR"
	cd "$TERMUX_PKG_HOSTBUILD_DIR"

	termux_setup_cmake

	cmake .
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWAMR_BUILD_TARGET=AARCH64"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWAMR_BUILD_TARGET=THUMB"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWAMR_BUILD_TARGET=X86_32"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWAMR_BUILD_TARGET=X86_64"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	LDFLAGS+=" -landroid-spawn"
}

termux_step_post_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" tjs
}
