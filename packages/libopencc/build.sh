TERMUX_PKG_HOMEPAGE=https://github.com/BYVoid/OpenCC
TERMUX_PKG_DESCRIPTION="An opensource project for conversions between Traditional Chinese, Simplified Chinese and Japanese Kanji (Shinjitai)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.3
TERMUX_PKG_SRCURL=https://github.com/BYVoid/OpenCC/archive/ver.${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=99a9af883b304f11f3b0f6df30d9fb4161f15b848803f9ff9c65a96d59ce877f
TERMUX_PKG_DEPENDS="libc++, marisa"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_SYSTEM_MARISA=ON"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_cmake
	cmake $TERMUX_PKG_SRCDIR
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_post_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/src/tools:$PATH
}
