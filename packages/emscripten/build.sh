TERMUX_PKG_HOMEPAGE=https://emscripten.org
TERMUX_PKG_DESCRIPTION="Emscripten: An LLVM-to-WebAssembly Compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@truboxl"
TERMUX_PKG_VERSION=2.0.31
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/emscripten-core/emscripten.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RECOMMENDS="emscripten-llvm, emscripten-binaryen, python, nodejs-lts | nodejs, debianutils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true

# https://github.com/emscripten-core/emscripten/blob/main/docs/packaging.md
# https://github.com/archlinux/svntogit-community/tree/packages/emscripten/trunk
# below generates commit hash for the deps according to emscripten releases
#RELEASES_TAGS=$(curl -s https://raw.githubusercontent.com/emscripten-core/emsdk/main/emscripten-releases-tags.json)
#RELEASE_TAG=$(echo $RELEASES_TAGS | python3 -c "import json,sys;print(json.load(sys.stdin)[\"releases\"][\"$TERMUX_PKG_VERSION\"])")
#DEPS_REVISION=$(curl -s https://chromium.googlesource.com/emscripten-releases/+/$RELEASE_TAG/DEPS?format=text | base64 -d | grep "_revision':" | sed -e "s|'|\"|g")
#DEPS_JSON=$(echo -e "{\n${DEPS_REVISION}EOL" | sed -e "s|,EOL|\n}|")
#LLVM_COMMIT=$(echo $DEPS_JSON | python3 -c "import json,sys;print(json.load(sys.stdin)[\"llvm_project_revision\"])")
#BINARYEN_COMMIT=$(echo $DEPS_JSON | python3 -c "import json,sys;print(json.load(sys.stdin)[\"binaryen_revision\"])")
#curl -LOC - https://github.com/llvm/llvm-project/archive/$LLVM_COMMIT.tar.gz
#curl -LOC - https://github.com/WebAssembly/binaryen/archive/$BINARYEN_COMMIT.tar.gz
#sha256sum $LLVM_COMMIT.tar.gz $BINARYEN_COMMIT.tar.gz

# https://github.com/emscripten-core/emscripten/issues/11362
# can switch to stable LLVM to save space once above is fixed
LLVM_COMMIT=8fa2394bad433558f3083cee158043e2fb66d781
LLVM_TGZ_SHA256=5199e1e459a9b1308e145d775c540bac72d0a75b81a4558d08ffd7444412f8d1

# https://github.com/emscripten-core/emscripten/issues/12252
# upstream says better bundle the right binaryen revision for now
BINARYEN_COMMIT=65bcde2c30e82047a892332b95b114bc86f89614
BINARYEN_TGZ_SHA256=093bf206d34a7e239b4ae9dd9e9f393099622cebaa781d859b0f85e2305735d4

# https://github.com/emscripten-core/emsdk/blob/main/emsdk.py
# https://chromium.googlesource.com/emscripten-releases/+/refs/heads/main/src/build.py
# https://github.com/llvm/llvm-project
LLVM_BUILD_ARGS="
-DCMAKE_BUILD_TYPE=MinSizeRel
-DCMAKE_CROSSCOMPILING=ON
-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX/opt/emscripten-llvm

-DDEFAULT_SYSROOT=$(dirname $TERMUX_PREFIX)
-DGENERATOR_IS_MULTI_CONFIG=ON
-DLLVM_ENABLE_ASSERTIONS=ON
-DLLVM_ENABLE_BINDINGS=OFF
-DLLVM_ENABLE_LIBEDIT=OFF
-DLLVM_ENABLE_LIBPFM=OFF
-DLLVM_ENABLE_LIBXML2=OFF
-DLLVM_ENABLE_PROJECTS=clang;compiler-rt;libunwind;lld
-DLLVM_ENABLE_TERMINFO=OFF
-DLLVM_INCLUDE_EXAMPLES=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen

-DCLANG_ENABLE_ARCMT=OFF
-DCLANG_ENABLE_STATIC_ANALYZER=OFF
-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen

-DCOMPILER_RT_BUILD_CRT=OFF
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
-DCOMPILER_RT_BUILD_MEMPROF=OFF
-DCOMPILER_RT_BUILD_PROFILE=OFF
-DCOMPILER_RT_BUILD_SANITIZERS=OFF
-DCOMPILER_RT_BUILD_XRAY=OFF
-DCOMPILER_RT_INCLUDE_TESTS=OFF

-DLIBUNWIND_USE_COMPILER_RT=ON
"

# https://github.com/WebAssembly/binaryen/blob/main/CMakeLists.txt
BINARYEN_BUILD_ARGS="
-DCMAKE_BUILD_TYPE=MinSizeRel
-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX/opt/emscripten-binaryen
"

termux_step_post_get_source() {
	termux_download \
		"https://github.com/llvm/llvm-project/archive/$LLVM_COMMIT.tar.gz" \
		"$TERMUX_PKG_CACHEDIR/llvm.tar.gz" \
		"$LLVM_TGZ_SHA256"
	termux_download \
		"https://github.com/WebAssembly/binaryen/archive/$BINARYEN_COMMIT.tar.gz" \
		"$TERMUX_PKG_CACHEDIR/binaryen.tar.gz" \
		"$BINARYEN_TGZ_SHA256"
	tar -xf "$TERMUX_PKG_CACHEDIR/llvm.tar.gz" -C "$TERMUX_PKG_CACHEDIR"
	tar -xf "$TERMUX_PKG_CACHEDIR/binaryen.tar.gz" -C "$TERMUX_PKG_CACHEDIR"

	cd "$TERMUX_PKG_CACHEDIR/llvm-project-$LLVM_COMMIT"
	git apply "$TERMUX_PKG_BUILDER_DIR/llvm-project.git-patch.txt"
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-S "$TERMUX_PKG_CACHEDIR/llvm-project-$LLVM_COMMIT/llvm" \
		-DLLVM_ENABLE_PROJECTS=clang
	cmake \
		--build "$TERMUX_PKG_HOSTBUILD_DIR" \
		-j "$TERMUX_MAKE_PROCESSES" \
		--target llvm-tblgen clang-tblgen
}

termux_step_make() {
	termux_setup_cmake
	termux_setup_ninja

	# from packages/libllvm/build.sh
	export LLVM_DEFAULT_TARGET_TRIPLE=${CCTERMUX_HOST_PLATFORM/-/-unknown-}
	export LLVM_TARGET_ARCH
	if [ $TERMUX_ARCH = "arm" ]; then
		LLVM_TARGET_ARCH=ARM
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		LLVM_TARGET_ARCH=AArch64
	elif [ $TERMUX_ARCH = "i686" ] || [ $TERMUX_ARCH = "x86_64" ]; then
		LLVM_TARGET_ARCH=X86
	else
		termux_error_exit "Invalid arch: $TERMUX_ARCH"
	fi

	LLVM_BUILD_ARGS+=" -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH"
	LLVM_BUILD_ARGS+=" -DLLVM_TARGETS_TO_BUILD=WebAssembly;$LLVM_TARGET_ARCH"
	LLVM_BUILD_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"

	cmake \
		-G Ninja \
		-S "$TERMUX_PKG_CACHEDIR/llvm-project-$LLVM_COMMIT/llvm" \
		-B "$TERMUX_PKG_CACHEDIR/build-llvm" \
		$LLVM_BUILD_ARGS
	cmake \
		--build "$TERMUX_PKG_CACHEDIR/build-llvm" \
		-j "$TERMUX_MAKE_PROCESSES" \
		--target install

	cmake \
		-G Ninja \
		-S "$TERMUX_PKG_CACHEDIR/binaryen-$BINARYEN_COMMIT" \
		-B "$TERMUX_PKG_CACHEDIR/build-binaryen" \
		$BINARYEN_BUILD_ARGS
	cmake \
		--build "$TERMUX_PKG_CACHEDIR/build-binaryen" \
		-j "$TERMUX_MAKE_PROCESSES" \
		--target install
}

termux_step_make_install() {
	# skip using Makefile which does host npm install, tar archive and extract steps
	rm -fr "$TERMUX_PREFIX/opt/emscripten"
	./tools/install.py "$TERMUX_PREFIX/opt/emscripten"

	# first run generates .emscripten and exits immediately
	rm -f "$TERMUX_PKG_SRCDIR/.emscripten"
	./emcc
	sed -i .emscripten -e "s|^EMSCRIPTEN_ROOT.*|EMSCRIPTEN_ROOT = '$TERMUX_PREFIX/opt/emscripten' # directory|"
	sed -i .emscripten -e "s|^LLVM_ROOT.*|LLVM_ROOT = '$TERMUX_PREFIX/opt/emscripten-llvm/bin' # directory|"
	sed -i .emscripten -e "s|^BINARYEN_ROOT.*|BINARYEN_ROOT = '$TERMUX_PREFIX/opt/emscripten-binaryen' # directory|"
	sed -i .emscripten -e "s|^NODE_JS.*|NODE_JS = '$TERMUX_PREFIX/bin/node' # executable|"
	grep "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/.emscripten"
	install -Dm644 "$TERMUX_PKG_SRCDIR/.emscripten" "$TERMUX_PREFIX/opt/emscripten/.emscripten"

	# https://github.com/emscripten-core/emscripten/issues/9098 (fixed in 2.0.17)
	cat <<- EOF > "$TERMUX_PKG_TMPDIR/emscripten.sh"
	#!$TERMUX_PREFIX/bin/sh
	export PATH=\$PATH:$TERMUX_PREFIX/opt/emscripten
	EOF
	install -Dm644 "$TERMUX_PKG_TMPDIR/emscripten.sh" "$TERMUX_PREFIX/etc/profile.d/emscripten.sh"

	# remove unneeded files
	for tool in clang-{check,cl,cpp,extdef-mapping,format,func-mapping,import-test,offload-bundler,refactor,rename,scan-deps} \
		lld-link ld.lld ld64.lld llvm-lib ld64.lld.darwin{new,old}; do
		rm -f "$TERMUX_PREFIX/opt/emscripten-llvm/bin/$tool"
	done
	rm -f $TERMUX_PREFIX/opt/emscripten-llvm/lib/libclang.so*
	rm -fr "$TERMUX_PREFIX/opt/emscripten-llvm/share"

	# termux_step_install_license also handles LICENSE file
	rm -f "$TERMUX_PREFIX/opt/emscripten/LICENSE"

	# add useful tools not installed by LLVM_INSTALL_TOOLCHAIN_ONLY=ON
	for tool in FileCheck llc llvm-{as,dis,link,mc,nm,objdump,readobj,size,dwarfdump,dwp} opt; do
		install -Dm755 "$TERMUX_PKG_CACHEDIR/build-llvm/bin/$tool" "$TERMUX_PREFIX/opt/emscripten-llvm/bin/$tool"
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ -n "\$(which npm)" ]; then
	echo 'Running "npm ci --no-optional --production" in $TERMUX_PREFIX/opt/emscripten ...'
	cd "$TERMUX_PREFIX/opt/emscripten"
	npm ci --no-optional --production
	else
	echo 'Warning: npm is not installed! Emscripten may not work properly without installing node modules!' >&2
	fi
	echo '
	====================
	Post-install notice:
	If this is the first time installing Emscripten,
	please start a new session to take effect.
	If you are upgrading, you may want to clear the
	cache by running the command below to fix issues.
	"emcc --clear-cache"

	Optional: Run the command below in Emscripten
	directory to install tests dependencies before
	running test suite.
	"npm ci --no-optional"'
	if [ -d "$TERMUX_PREFIX/lib/emscripten" ]; then
	echo '
	Note: The old Emscripten path has been deprecated.
	To delete, simply run the command below.
	"rm -fr $TERMUX_PREFIX/lib/emscripten"'
	fi
	echo '
	===================='
	EOF

	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	case "\$1" in
	purge|remove)
	rm -fr "$TERMUX_PREFIX/opt/emscripten"
	esac
	EOF
}
