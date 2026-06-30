TERMUX_PKG_HOMEPAGE=https://libclc.llvm.org/
TERMUX_PKG_DESCRIPTION="Open source implementation of the library requirements of the OpenCL C programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_LICENSE_FILE="libclc/LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	22.1.6 # Keep in sync with libllvm
	22.1.2 # Keep in sync with spirv-llvm-translator
)
TERMUX_PKG_SRCURL=(
	"https://github.com/llvm/llvm-project/releases/download/llvmorg-${TERMUX_PKG_VERSION[0]}/llvm-project-${TERMUX_PKG_VERSION[0]}.src.tar.xz"
	"https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz"
)
TERMUX_PKG_SHA256=(
	6e0b376a1f6d9873e7dfb09ae6e04b9c7024400f01733fa4c29be69d5c138bc2
	b37196b1a1a60282a24cf937ab7d6807d7d54dc718f2a37a78e211be26df57ac
)
TERMUX_PKG_BUILD_DEPENDS="clang, libc++, libllvm, libllvm-static, lld, llvm, spirv-llvm-translator"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_AUTO_UPDATE=false

termux_step_post_get_source() {
	mkdir -p llvm/projects
	ln -fsv ../../"SPIRV-LLVM-Translator-${TERMUX_PKG_VERSION[1]}" llvm/projects
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
	rm -rf "$TERMUX_HOSTBUILD_MARKER"
	# also, termux_step_configure() does not do anything else for this package
}

termux_step_make() {
	:
}

termux_step_make_install() {
	:
}
