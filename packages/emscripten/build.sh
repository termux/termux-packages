TERMUX_PKG_HOMEPAGE=https://emscripten.org
TERMUX_PKG_DESCRIPTION="Emscripten: An LLVM-to-WebAssembly Compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.1"
TERMUX_PKG_SRCURL=git+https://github.com/emscripten-core/emscripten
TERMUX_PKG_GIT_BRANCH=${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="nodejs-lts | nodejs, python"
TERMUX_PKG_ANTI_BUILD_DEPENDS="nodejs, nodejs-lts, python"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

# remove files according to emsdk/upstream directory
# refer termux_step_post_get_source and termux_step_post_massage
TERMUX_PKG_RM_AFTER_INSTALL="
opt/emscripten-llvm/bin/amdgpu-arch
opt/emscripten-llvm/bin/clang-check
opt/emscripten-llvm/bin/clang-cl
opt/emscripten-llvm/bin/clang-cpp
opt/emscripten-llvm/bin/clang-extdef-mapping
opt/emscripten-llvm/bin/clang-format
opt/emscripten-llvm/bin/clang-func-mapping
opt/emscripten-llvm/bin/clang-import-test
opt/emscripten-llvm/bin/clang-installapi
opt/emscripten-llvm/bin/clang-linker-wrapper
opt/emscripten-llvm/bin/clang-nvlink-wrapper
opt/emscripten-llvm/bin/clang-offload-bundler
opt/emscripten-llvm/bin/clang-offload-packager
opt/emscripten-llvm/bin/clang-offload-wrapper
opt/emscripten-llvm/bin/clang-pseudo
opt/emscripten-llvm/bin/clang-refactor
opt/emscripten-llvm/bin/clang-rename
opt/emscripten-llvm/bin/clang-repl
opt/emscripten-llvm/bin/clang-sycl-linker
opt/emscripten-llvm/bin/diagtool
opt/emscripten-llvm/bin/git-clang-format
opt/emscripten-llvm/bin/hmaptool
opt/emscripten-llvm/bin/llvm-dlltool
opt/emscripten-llvm/bin/llvm-lib
opt/emscripten-llvm/bin/llvm-link
opt/emscripten-llvm/bin/llvm-mca
opt/emscripten-llvm/bin/llvm-ml
opt/emscripten-llvm/bin/llvm-ml64
opt/emscripten-llvm/bin/llvm-pdbutil
opt/emscripten-llvm/bin/llvm-profgen
opt/emscripten-llvm/bin/llvm-rc
opt/emscripten-llvm/bin/nvptx-arch
opt/emscripten-llvm/bin/offload-arch
opt/emscripten-llvm/lib/libclang.so*
opt/emscripten-llvm/share
opt/emscripten/LICENSE
"

# https://github.com/emscripten-core/emscripten/issues/11362
# can switch to stable LLVM to save space once above is fixed
_LLVM_COMMIT=b447f5d9763010f8c6806c578533291aef2bd484
_LLVM_TGZ_SHA256=6d871689958255fce2ebee99e5055f5167c9451a6bc32332b1a2409fdf138842

# https://github.com/emscripten-core/emscripten/issues/12252
# upstream says better bundle the right binaryen revision for now
_BINARYEN_COMMIT=18ba06162272bc8bbf1fc29b5cb0832dd54becac
_BINARYEN_TGZ_SHA256=0bdb42545fde5ea45b239103d8343bce15170fa1f93b3aa498a3034184f79c07

# https://github.com/emscripten-core/emsdk/blob/main/emsdk.py
# https://chromium.googlesource.com/emscripten-releases/+/refs/heads/main/src/build.py
# https://github.com/llvm/llvm-project
_LLVM_BUILD_ARGS="
-DCMAKE_BUILD_TYPE=MinSizeRel
-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
-DCMAKE_CROSSCOMPILING=ON
-DCMAKE_INSTALL_PREFIX=${TERMUX_PREFIX}/opt/emscripten-llvm
-DDEFAULT_SYSROOT=$(dirname ${TERMUX_PREFIX})
-DLLVM_ENABLE_ASSERTIONS=ON
-DLLVM_ENABLE_BINDINGS=OFF
-DLLVM_ENABLE_LIBEDIT=OFF
-DLLVM_ENABLE_LIBPFM=OFF
-DLLVM_ENABLE_LIBXML2=OFF
-DLLVM_ENABLE_LTO=Thin
-DLLVM_ENABLE_PROJECTS=clang;lld
-DLLVM_INCLUDE_BENCHMARKS=OFF
-DLLVM_INCLUDE_EXAMPLES=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DLLVM_INCLUDE_UTILS=OFF
-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_NATIVE_TOOL_DIR=${TERMUX_PKG_HOSTBUILD_DIR}/bin
-DCLANG_DEFAULT_LINKER=lld
-DCLANG_ENABLE_ARCMT=OFF
-DCLANG_ENABLE_STATIC_ANALYZER=OFF
-DCLANG_LINKS_TO_CREATE=clang++;wasm32-clang;wasm32-clang++;wasm32-wasi-clang;wasm32-wasi-clang++
-DCOMPILER_RT_BUILD_CRT=OFF
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
-DCOMPILER_RT_BUILD_MEMPROF=OFF
-DCOMPILER_RT_BUILD_PROFILE=OFF
-DCOMPILER_RT_BUILD_SANITIZERS=OFF
-DCOMPILER_RT_BUILD_XRAY=OFF
-DCOMPILER_RT_INCLUDE_TESTS=OFF
-DLLD_SYMLINKS_TO_CREATE=wasm-ld
"

# https://github.com/WebAssembly/binaryen/blob/main/CMakeLists.txt
_BINARYEN_BUILD_ARGS="
-DCMAKE_INSTALL_PREFIX=${TERMUX_PREFIX}/opt/emscripten-binaryen
-DBUILD_TESTS=OFF
-DBYN_ENABLE_LTO=ON
"

# based on scripts/updates/internal/termux_github_auto_update.sh
termux_pkg_auto_update() {
	local latest_tag
	latest_tag=$(termux_github_api_get_tag)

	if [[ -z "${latest_tag}" ]]; then
		termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	fi

	if [[ "${latest_tag}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	# https://github.com/emscripten-core/emscripten/blob/main/docs/packaging.md
	# https://github.com/archlinux/svntogit-community/tree/packages/emscripten/trunk
	# below generates commit hash for the deps according to emscripten releases
	local tmpdir=$(mktemp -d)
	local releases_tags release_tag deps_revision deps_json llvm_commit binaryen_commit llvm_tgz_sha256 binaryen_tgz_sha256
	releases_tags=$(curl -s https://raw.githubusercontent.com/emscripten-core/emsdk/main/emscripten-releases-tags.json)
	release_tag=$(echo "${releases_tags}" | python3 -c "import json,sys;print(json.load(sys.stdin)[\"releases\"][\"${latest_tag}\"])")
	deps_revision=$(curl -s "https://chromium.googlesource.com/emscripten-releases/+/${release_tag}/DEPS?format=text" | base64 -d | grep "_revision':" | sed -e "s|'|\"|g")
	deps_json=$(echo -e "{\n${deps_revision}EOL" | sed -e "s|,EOL|\n}|")
	llvm_commit=$(echo "${deps_json}" | python3 -c "import json,sys;print(json.load(sys.stdin)[\"llvm_project_revision\"])")
	binaryen_commit=$(echo "${deps_json}" | python3 -c "import json,sys;print(json.load(sys.stdin)[\"binaryen_revision\"])")
	curl -LC - "https://github.com/llvm/llvm-project/archive/${llvm_commit}.tar.gz" -o "${tmpdir}/${llvm_commit}.tar.gz"
	curl -LC - "https://github.com/WebAssembly/binaryen/archive/${binaryen_commit}.tar.gz" -o "${tmpdir}/${binaryen_commit}.tar.gz"
	llvm_tgz_sha256=$(sha256sum "${tmpdir}/${llvm_commit}.tar.gz" | sed -e "s| .*$||")
	binaryen_tgz_sha256=$(sha256sum "${tmpdir}/${binaryen_commit}.tar.gz" | sed -e "s| .*$||")

	cat <<- EOL
	INFO: Generated *.tar.gz checksum for:
	_LLVM_COMMIT     ${llvm_commit} = ${llvm_tgz_sha256}
	_BINARYEN_COMMIT ${binaryen_commit} = ${binaryen_tgz_sha256}
	EOL

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_tag}."
		return
	fi

	sed \
		-e "s|^_LLVM_COMMIT=.*|_LLVM_COMMIT=${llvm_commit}|" \
		-e "s|^_LLVM_TGZ_SHA256=.*|_LLVM_TGZ_SHA256=${llvm_tgz_sha256}|" \
		-e "s|^_BINARYEN_COMMIT=.*|_BINARYEN_COMMIT=${binaryen_commit}|" \
		-e "s|^_BINARYEN_TGZ_SHA256=.*|_BINARYEN_TGZ_SHA256=${binaryen_tgz_sha256}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	rm -fr "${tmpdir}"

	termux_pkg_upgrade_version "$latest_tag"
}

termux_step_post_get_source() {
	# for comparing files in termux_step_post_massage
	if [[ ! -f "${TERMUX_PKG_CACHEDIR}/emsdk-fetched" || $(cat "${TERMUX_PKG_CACHEDIR}/emsdk-fetched") != "$TERMUX_PKG_VERSION" ]]; then
		pushd "${TERMUX_PKG_CACHEDIR}"
		rm -fr emsdk
		git clone https://github.com/emscripten-core/emsdk --depth=1
		cd emsdk
		./emsdk install latest
		echo "$TERMUX_PKG_VERSION" > "${TERMUX_PKG_CACHEDIR}"/emsdk-fetched
		popd
	fi

	termux_download \
		"https://github.com/llvm/llvm-project/archive/${_LLVM_COMMIT}.tar.gz" \
		"${TERMUX_PKG_CACHEDIR}/llvm.tar.gz" \
		"${_LLVM_TGZ_SHA256}"
	termux_download \
		"https://github.com/WebAssembly/binaryen/archive/${_BINARYEN_COMMIT}.tar.gz" \
		"${TERMUX_PKG_CACHEDIR}/binaryen.tar.gz" \
		"${_BINARYEN_TGZ_SHA256}"
	rm -rf "${TERMUX_PKG_CACHEDIR}/llvm-project-${_LLVM_COMMIT}"
	tar -xf "${TERMUX_PKG_CACHEDIR}/llvm.tar.gz" -C "${TERMUX_PKG_CACHEDIR}"
	rm -rf "${TERMUX_PKG_CACHEDIR}/binaryen-${_BINARYEN_COMMIT}"
	tar -xf "${TERMUX_PKG_CACHEDIR}/binaryen.tar.gz" -C "${TERMUX_PKG_CACHEDIR}"

	local llvm_patches=$(find "${TERMUX_PKG_BUILDER_DIR}" -mindepth 1 -maxdepth 1 -type f -name 'llvm-project-*.diff')
	if [[ -n "${llvm_patches}" ]]; then
		pushd "${TERMUX_PKG_CACHEDIR}/llvm-project-${_LLVM_COMMIT}"
		for patch in ${llvm_patches}; do
			patch -p1 -i "${patch}" || :
		done
		local llvm_patches_rej=$(find . -type f -name '*.rej')
		if [[ -n "${llvm_patches_rej}" ]]; then
			echo "INFO: Patch failed! Printing *.rej files ..."
			for rej in ${llvm_patches_rej}; do
				echo -e "\n\n${rej}"
				cat "${rej}"
			done
			termux_error_exit "Patch failed! Please check patch errors above!"
		fi
		popd
	fi

	local binaryen_patches=$(find "${TERMUX_PKG_BUILDER_DIR}" -mindepth 1 -maxdepth 1 -type f -name 'binaryen-*.diff')
	if [[ -n "${binaryen_patches}" ]]; then
		pushd "${TERMUX_PKG_CACHEDIR}/binaryen-${_BINARYEN_COMMIT}"
		for patch in ${binaryen_patches}; do
			patch -p1 -i "${patch}" || :
		done
		local binaryen_patches_rej=$(find . -type f -name '*.rej')
		if [[ -n "${binaryen_patches_rej}" ]]; then
			echo "INFO: Patch failed! Printing *.rej files ..."
			for rej in ${binaryen_patches_rej}; do
				echo -e "\n\n${rej}"
				cat "${rej}"
			done
			termux_error_exit "Patch failed! Please check patch errors above!"
		fi
		popd
	fi
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_CACHEDIR}/llvm-project-${_LLVM_COMMIT}/llvm" \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_PROJECTS=clang \
		-DLLVM_INCLUDE_BENCHMARKS=OFF \
		-DLLVM_INCLUDE_EXAMPLES=OFF \
		-DLLVM_INCLUDE_TESTS=OFF \
		-DLLVM_INCLUDE_UTILS=OFF
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" \
		llvm-tblgen clang-tblgen
}

termux_step_pre_configure() {
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", emscripten-binaryen, emscripten-llvm"

	termux_setup_cmake
	termux_setup_ninja

	# emscripten 4.0.11
	# for "npm ci --omit=dev" in ./tools/install.py
	# but we still remove "node_modules" directory in make install step
	termux_setup_nodejs

	# https://github.com/termux/termux-packages/issues/16358
	# TODO libclang-cpp.so* is not affected
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		echo "WARN: ld.lld wrapper is not working for on-device builds. Skipping."
		return
	fi

	local _WRAPPER_BIN=${TERMUX_PKG_BUILDDIR}/_wrapper/bin
	mkdir -p "${_WRAPPER_BIN}"
	ln -fs "${TERMUX_STANDALONE_TOOLCHAIN}/bin/lld" "${_WRAPPER_BIN}/ld.lld"
	cat <<- EOF > "${_WRAPPER_BIN}/ld.lld.sh"
	#!/bin/bash
	tmpfile=\$(mktemp)
	python ${TERMUX_PKG_BUILDER_DIR}/fix-rpath.py -rpath=${TERMUX_PREFIX}/lib \$@ > \${tmpfile}
	args=\$(cat \${tmpfile})
	rm -f \${tmpfile}
	${_WRAPPER_BIN}/ld.lld \${args}
	EOF
	chmod +x "${_WRAPPER_BIN}/ld.lld.sh"
	rm -f "${TERMUX_STANDALONE_TOOLCHAIN}/bin/ld.lld"
	ln -fs "${_WRAPPER_BIN}/ld.lld.sh" "${TERMUX_STANDALONE_TOOLCHAIN}/bin/ld.lld"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	# from packages/libllvm/build.sh
	local _LLVM_TARGET_TRIPLE=${TERMUX_HOST_PLATFORM/-/-unknown-}${TERMUX_PKG_API_LEVEL}
	local _LLVM_TARGET_ARCH
	case "${TERMUX_ARCH}" in
	aarch64) _LLVM_TARGET_ARCH="AArch64" ;;
	arm) _LLVM_TARGET_ARCH="ARM" ;;
	i686|x86_64) _LLVM_TARGET_ARCH="X86" ;;
	*) termux_error_exit "Invalid arch: ${TERMUX_ARCH}" ;;
	esac
	_LLVM_BUILD_ARGS+="
	-DLLVM_HOST_TRIPLE=${_LLVM_TARGET_TRIPLE}
	-DLLVM_TARGET_ARCH=${_LLVM_TARGET_ARCH}
	-DLLVM_TARGETS_TO_BUILD=WebAssembly;${_LLVM_TARGET_ARCH}
	"

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_CACHEDIR}/llvm-project-${_LLVM_COMMIT}/llvm" \
		-B "${TERMUX_PKG_BUILDDIR}/build-llvm" \
		${_LLVM_BUILD_ARGS}
	ninja \
		-C "${TERMUX_PKG_BUILDDIR}/build-llvm" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" \
		install

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_CACHEDIR}/binaryen-${_BINARYEN_COMMIT}" \
		-B "${TERMUX_PKG_BUILDDIR}/build-binaryen" \
		${_BINARYEN_BUILD_ARGS}
	ninja \
		-C "${TERMUX_PKG_BUILDDIR}/build-binaryen" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" \
		install

	pushd "${TERMUX_PKG_SRCDIR}"

	# emscripten 4.0.13
	# https://github.com/emscripten-core/emscripten/pull/23761
	# https://github.com/termux/termux-packages/issues/25777
	./tools/maint/create_entry_points.py

	# https://github.com/emscripten-core/emscripten/pull/15840
	sed -e "s|-git||" -i "${TERMUX_PKG_SRCDIR}/emscripten-version.txt"

	# skip using Makefile which does host npm install
	rm -fr "${TERMUX_PREFIX}/opt/emscripten"
	./tools/install.py "${TERMUX_PREFIX}/opt/emscripten"

	# remove node_modules directory
	# to be installed on device post install
	rm -fr "${TERMUX_PREFIX}/opt/emscripten/node_modules"

	# subpackage optional third party test suite files
	cp -fr "${TERMUX_PKG_SRCDIR}/test/third_party" "${TERMUX_PREFIX}/opt/emscripten/test/third_party"

	# first run generates .emscripten and exits immediately
	rm -f "${TERMUX_PKG_SRCDIR}/.emscripten"
	./emcc --generate-config
	sed \
		-e "s|^EMSCRIPTEN_ROOT.*|EMSCRIPTEN_ROOT = '${TERMUX_PREFIX}/opt/emscripten' # directory|" \
		-e "s|^LLVM_ROOT.*|LLVM_ROOT = '${TERMUX_PREFIX}/opt/emscripten-llvm/bin' # directory|" \
		-e "s|^BINARYEN_ROOT.*|BINARYEN_ROOT = '${TERMUX_PREFIX}/opt/emscripten-binaryen' # directory|" \
		-e "s|^NODE_JS.*|NODE_JS = '${TERMUX_PREFIX}/bin/node' # executable|" \
		-i .emscripten
	grep "${TERMUX_PREFIX}" "${TERMUX_PKG_SRCDIR}/.emscripten"
	install -Dm644 "${TERMUX_PKG_SRCDIR}/.emscripten" "${TERMUX_PREFIX}/opt/emscripten/.emscripten"

	# add emscripten directory to PATH var
	cat <<- EOF > "${TERMUX_PKG_TMPDIR}/emscripten.sh"
	#!${TERMUX_PREFIX}/bin/sh
	export PATH=\${PATH}:${TERMUX_PREFIX}/opt/emscripten
	EOF
	install -Dm644 "${TERMUX_PKG_TMPDIR}/emscripten.sh" "${TERMUX_PREFIX}/etc/profile.d/emscripten.sh"

	# add useful tools not installed by LLVM_INSTALL_TOOLCHAIN_ONLY=ON
	for tool in llvm-{addr2line,dwarfdump,dwp,link,nm,objdump,ranlib,readobj,size,strings}; do
		install -Dm755 "${TERMUX_PKG_BUILDDIR}/build-llvm/bin/${tool}" "${TERMUX_PREFIX}/opt/emscripten-llvm/bin/${tool}"
	done

	# termux_step_massage strip does not cover opt dir
	find "${TERMUX_PREFIX}/opt" \( \
		-path "*/emscripten-llvm/bin/*" -o \
		-path "*/emscripten-llvm/lib/*" -o \
		-path "*/emscripten-binaryen/bin/*" -o \
		-path "*/emscripten-binaryen/lib/*" \
	\) -type f -print0 | \
		xargs -0 -r file | grep -E "ELF .+ (executable|shared object)" | \
		cut -d":" -f1 | xargs -r "${STRIP}" --strip-unneeded --preserve-dates

	popd
}

termux_step_post_massage() {
	local upstream_bin=$(ls "${TERMUX_PKG_CACHEDIR}/emsdk/upstream/bin")
	local llvm_bin=$(ls "${TERMUX_TOPDIR}/emscripten/subpackages/emscripten-llvm/massage/${TERMUX_PREFIX_CLASSICAL}/opt/emscripten-llvm/bin")
	local binaryen_bin=$(ls "${TERMUX_TOPDIR}/emscripten/subpackages/emscripten-binaryen/massage/${TERMUX_PREFIX_CLASSICAL}/opt/emscripten-binaryen/bin")
	local df=$(diff -u <(echo "${upstream_bin}") <(echo -e "${llvm_bin}\n${binaryen_bin}" | sort))
	if [[ -n "${df}" ]]; then
		termux_error_exit "Mismatch list of binaries with upstream:\n${df}"
	fi

	local upstream_entrypoint=$(find "${TERMUX_PKG_CACHEDIR}/emsdk/upstream/emscripten" -mindepth 1 -maxdepth 1 -type f | xargs -i bash -c "[[ -x '{}' ]] && basename '{}'" | sort)
	local downstream_entrypoint=$(find "${TERMUX_PREFIX}/opt/emscripten" -mindepth 1 -maxdepth 1 -type f | xargs -i bash -c "[[ -x '{}' ]] && basename '{}'" | sort)
	local df2=$(diff -u <(echo "${upstream_entrypoint}") <(echo "${downstream_entrypoint}"))
	if [[ -n "${df2}" ]]; then
		termux_error_exit "Mismatch list of entrypoints with upstream:\n${df2}"
	fi
}

termux_step_create_debscripts() {
	# emscripten's package-lock.json is generated with nodejs v12.13.0
	# which comes with npm v6 which used lockfile version 1
	# which isn't compatible with lockfile version 2 used in npm v7 and v8
	sed \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"${TERMUX_PKG_BUILDER_DIR}/postinst.sh" > postinst
	sed \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"${TERMUX_PKG_BUILDER_DIR}/postrm.sh" > postrm

	chmod u+x postinst postrm
}
