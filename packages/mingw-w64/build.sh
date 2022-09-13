TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="MinGW-w64 toolchain (metapackage)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="clang, mingw-w64-crt, mingw-w64-gcc-libs"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p ${TERMUX_PREFIX}/bin
	local arch
	for arch in x86_64 i686; do
		local target="${arch}-w64-mingw32"
		local sysroot="${TERMUX_PREFIX}/${target}"
		local clang_opts="--start-no-unused-arguments"
		clang_opts+=" --target=${target}"
		clang_opts+=" --sysroot=${sysroot}"
		clang_opts+=" -fuse-ld=lld"
		clang_opts+=" -rtlib=libgcc"
		local clangxx_opts="${clang_opts} -stdlib=libstdc++"
		clang_opts+=" --end-no-unused-arguments"
		clangxx_opts+=" --end-no-unused-arguments"
		cat > ${TERMUX_PREFIX}/bin/${target}-clang <<-EOF
			#!${TERMUX_PREFIX}/bin/sh
			exec clang ${clang_opts} "\$@"
		EOF
		chmod 0700 ${TERMUX_PREFIX}/bin/${target}-clang
		cat > ${TERMUX_PREFIX}/bin/${target}-clang++ <<-EOF
			#!${TERMUX_PREFIX}/bin/sh
			exec clang++ ${clangxx_opts} "\$@"
		EOF
		chmod 0700 ${TERMUX_PREFIX}/bin/${target}-clang++
	done
}
