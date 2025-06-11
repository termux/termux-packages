TERMUX_PKG_HOMEPAGE=https://libclc.llvm.org/
TERMUX_PKG_DESCRIPTION="Open source implementation of the library requirements of the OpenCL C programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_LICENSE_FILE="libclc/LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@termux"
LLVM_MAJOR_VERSION=20
TERMUX_PKG_VERSION=(
	${LLVM_MAJOR_VERSION}.1.7
	${LLVM_MAJOR_VERSION}.1.3
)
TERMUX_PKG_SRCURL=(
	https://github.com/llvm/llvm-project/releases/download/llvmorg-${TERMUX_PKG_VERSION[0]}/llvm-project-${TERMUX_PKG_VERSION[0]}.src.tar.xz
	https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz
)
TERMUX_PKG_SHA256=(
	cd8fd55d97ad3e360b1d5aaf98388d1f70dfffb7df36beee478be3b839ff9008
	8e953931a09b0a4c2a77ddc8f1df4783571d8ffca9546150346c401573866062
)
TERMUX_PKG_BUILD_DEPENDS="clang, libc++, libllvm, libllvm-static, lld, llvm, spirv-llvm-translator"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_FORCE_CMAKE=true

termux_step_post_get_source() {
	mkdir -p llvm/projects
	ln -fsv ../../SPIRV-LLVM-Translator-${TERMUX_PKG_VERSION[1]} llvm/projects
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-B llvm \
		-S "${TERMUX_PKG_SRCDIR}/llvm" \
		-G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_PROJECTS="clang" \
		-DLLVM_INCLUDE_BENCHMARKS=OFF \
		-DLLVM_INCLUDE_EXAMPLES=OFF \
		-DLLVM_INCLUDE_TESTS=OFF \
		-DLLVM_INCLUDE_UTILS=OFF
	ninja \
		-C llvm \
		-j "$TERMUX_PKG_MAKE_PROCESSES" \
		clang llvm-as llvm-link llvm-spirv opt

	export PATH="${TERMUX_PKG_HOSTBUILD_DIR}/bin:${PATH}"

	cmake \
		-B libclc \
		-S "${TERMUX_PKG_SRCDIR}/libclc" \
		-G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_DIR="${TERMUX_PKG_HOSTBUILD_DIR}/llvm/lib/llvm" \
		-DCMAKE_INSTALL_PREFIX="${TERMUX_PREFIX}"
	ninja \
		-C libclc \
		-j "$TERMUX_PKG_MAKE_PROCESSES"
	ninja \
		-C libclc \
		-j "$TERMUX_PKG_MAKE_PROCESSES" \
		install

	echo "INFO: ${TERMUX_PREFIX}/share/pkgconfig/libclc.pc"
	cat "${TERMUX_PREFIX}/share/pkgconfig/libclc.pc"
	echo
}

termux_step_configure() {
	# always remove this marker because this package is built in termux_step_host_build()
	# this prevents "ERROR: No files in package." when the package is built again without deleting
	# the docker container.
	rm -rf $TERMUX_HOSTBUILD_MARKER
	# also, termux_step_configure() does not do anything else for this package
}

termux_step_make() {
	:
}

termux_step_make_install() {
	:
}
