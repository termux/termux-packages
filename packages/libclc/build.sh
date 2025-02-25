TERMUX_PKG_HOMEPAGE=https://libclc.llvm.org/
TERMUX_PKG_DESCRIPTION="Library requirements of the OpenCL C programming language"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-pacman"
TERMUX_PKG_VERSION=19.1.3
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-$TERMUX_PKG_VERSION/libclc-$TERMUX_PKG_VERSION.src.tar.xz
TERMUX_PKG_SHA256=b49fab401aaa65272f0480f6d707a9a175ea8e68b6c5aa910457c4166aa6328f
# TERMUX_PKG_BUILD_DEPENDS="clang, python, spirv-llvm-translator"

# don't remove my files ok
TERMUX_NO_CLEAN=true

# how do I DISABLE cross compiling this packet is only data
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CMAKE_CROSSCOMPILING=false
termux_step_handle_host_build() { :; }
termux_step_setup_toolchain() {
	CC=clang
	READELF=readelf
	STRIP=strip
 }
termux_setup_cmake() { :; }
termux_setup_ninja() { :; }
termux_step_configure_cmake() { :; }

  # so none of this is linked to anything on ARM? it is all data? why is  it only in the glibc prefix how is bionic supposed to find anything 
termux_step_pre_configure2() {
# it needs th LLVM optimiser opt ? ?  where is it ? ?
 	# -DCMAKE_LLVM_OPT=$TERMUX_STANDALONE_TOOLCHAIN/bin/opt
	ln -s /usr/lib/llvm-19/bin/opt $TERMUX_STANDALONE_TOOLCHAIN/bin/opt     -f
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
 	-DCMAKE_C_COMPILER=$TERMUX_STANDALONE_TOOLCHAIN/bin/clang
	-DLIBCLC_CUSTOM_LLVM_TOOLS_BINARY_DIR=$TERMUX_STANDALONE_TOOLCHAIN/bin
	"
		# CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_C_COMPILER=$TERMUX_STANDALONE_TOOLCHAIN/bin/clang")
		# CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_CXX_COMPILER=$TERMUX_STANDALONE_TOOLCHAIN/bin/clang++")
		
		# how do inset this
  # set( prepare_builtins_exe ./prepare_builtins )

}

termux_step_configure() {
	termux_setup_ninja
	termux_setup_cmake

	local OLD_PATH="${PATH}"
	# export PATH="${TERMUX_PREFIX}/bin:${PATH}"
	# export CC=clang

	cmake ${TERMUX_PKG_SRCDIR} \
		-G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX
		# -DCMAKE_C_COMPILER=/usr/bin/clang               
	export PATH=$OLD_PATH
}

termux_step_make() {
	local OLD_PATH="${PATH}"
	# export PATH="${TERMUX_PREFIX}/bin:${PATH}"

	ninja

	export PATH=$OLD_PATH
}
