TERMUX_PKG_HOMEPAGE=https://github.com/BYVoid/OpenCC
TERMUX_PKG_DESCRIPTION="An opensource project for conversions between Traditional Chinese, Simplified Chinese and Japanese Kanji (Shinjitai)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.4
TERMUX_PKG_SRCURL=https://github.com/BYVoid/OpenCC/archive/ver.${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ca33cf2a2bf691ee44f53397c319bb50c6d6c4eff1931a259fd11533ba26c1e9
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
