TERMUX_PKG_HOMEPAGE=https://github.com/BYVoid/OpenCC
TERMUX_PKG_DESCRIPTION="An opensource project for conversions between Traditional Chinese, Simplified Chinese and Japanese Kanji (Shinjitai)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL=https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=088483cd6051d06c2850eefba33b3c30a6e34485027bbc8949eb90548d6f714e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, marisa"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DOPENCC_HOST_BIN=$TERMUX_PKG_HOSTBUILD_DIR/src/tools/opencc
-DOPENCC_DICT_HOST_BIN=$TERMUX_PKG_HOSTBUILD_DIR/src/tools/opencc_dict
-DUSE_SYSTEM_MARISA=ON
"

termux_step_host_build() {
	termux_setup_cmake
	cmake $TERMUX_PKG_SRCDIR
	make -j $TERMUX_PKG_MAKE_PROCESSES
}
