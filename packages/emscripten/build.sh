TERMUX_PKG_HOMEPAGE=https://emscripten.org
TERMUX_PKG_DESCRIPTION="Emscripten: An LLVM-to-WebAssembly Compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@truboxl"
TERMUX_PKG_VERSION=2.0.17
TERMUX_PKG_SRCURL=https://github.com/emscripten-core/emscripten.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="python, nodejs"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RECOMMENDS="emscripten-llvm, emscripten-binaryen"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true

# https://github.com/emscripten-core/emscripten/blob/main/docs/packaging.md
# https://github.com/archlinux/svntogit-community/tree/packages/emscripten/trunk
# below generates commit hash for the deps according to emscripten releases
#RELEASES_TAGS=$(curl -s https://raw.githubusercontent.com/emscripten-core/emsdk/master/emscripten-releases-tags.txt)
#RELEASE_TAG=$(echo $RELEASES_TAGS | python3 -c "import json,sys;print(json.load(sys.stdin)[\"releases\"][\"$TERMUX_PKG_VERSION\"])")
#DEPS_REVISION=$(curl -s https://chromium.googlesource.com/emscripten-releases/+/$RELEASE_TAG/DEPS?format=text | base64 -d | grep "_revision':" | sed -e "s|'|\"|g")
#DEPS_JSON=$(echo -e "{\n${DEPS_REVISION}EOL" | sed -e "s|,EOL|\n}|")
#LLVM_COMMIT=$(echo $DEPS_JSON | python3 -c "import json,sys;print(json.load(sys.stdin)[\"llvm_project_revision\"])")
#BINARYEN_COMMIT=$(echo $DEPS_JSON | python3 -c "import json,sys;print(json.load(sys.stdin)[\"binaryen_revision\"])")

# https://github.com/emscripten-core/emscripten/issues/11362
# can switch to stable LLVM to save space once above is fixed
LLVM_COMMIT=3b677b81cec7b3c5132aee8fccc30252d87deb69
LLVM_ZIP_SHA256=dbb9ccc1788129abd6dae4e4132758942a6930f3a73530d39745fe23f241ba26

# https://github.com/emscripten-core/emscripten/issues/12252
# upstream says better bundle the right binaryen revision for now
BINARYEN_COMMIT=b2c63a9665a9758c50eac60af605f0399f66580f
BINARYEN_ZIP_SHA256=a78d0ddb1e4a1c80440e6a7e5240134757ab85e16c27474ba7265c13b5500ddd

# https://github.com/emscripten-core/emsdk/blob/master/emsdk.py
# https://github.com/WebAssembly/waterfall/blob/master/src/build.py
# https://github.com/llvm/llvm-project/blob/main/llvm/CMakeLists.txt
# https://github.com/llvm/llvm-project/blob/main/clang/CMakeLists.txt
LLVM_BUILD_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX/lib/emscripten-llvm
-DLLVM_INCLUDE_EXAMPLES=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DLLVM_ENABLE_ASSERTIONS=OFF
-DLLVM_ENABLE_PROJECTS='clang;lld'
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen
-DGENERATOR_IS_MULTI_CONFIG=ON
-DDEFAULT_SYSROOT=$(dirname $TERMUX_PREFIX)
-DCMAKE_SKIP_RPATH=ON
-DLLVM_ENABLE_LIBXML2=OFF
-DLLVM_ENABLE_BINDINGS=OFF
-DCLANG_ENABLE_ARCMT=OFF
-DCLANG_ENABLE_STATIC_ANALYZER=OFF
-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
"

# https://github.com/WebAssembly/binaryen/blob/main/CMakeLists.txt
BINARYEN_BUILD_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX/lib/emscripten-binaryen
"

termux_step_post_get_source() {
	termux_download \
		"https://github.com/llvm/llvm-project/archive/$LLVM_COMMIT.zip" \
		"$TERMUX_PKG_CACHEDIR/llvm.zip" \
		"$LLVM_ZIP_SHA256"
	termux_download \
		"https://github.com/WebAssembly/binaryen/archive/$BINARYEN_COMMIT.zip" \
		"$TERMUX_PKG_CACHEDIR/binaryen.zip" \
		"$BINARYEN_ZIP_SHA256"
	unzip -qo "$TERMUX_PKG_CACHEDIR/llvm.zip" -d "$TERMUX_PKG_CACHEDIR"
	unzip -qo "$TERMUX_PKG_CACHEDIR/binaryen.zip" -d "$TERMUX_PKG_CACHEDIR"
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-DLLVM_ENABLE_PROJECTS='clang' \
		"$TERMUX_PKG_CACHEDIR/llvm-project-$LLVM_COMMIT/llvm"
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
		$LLVM_BUILD_ARGS \
		-S "$TERMUX_PKG_CACHEDIR/llvm-project-$LLVM_COMMIT/llvm" \
		-B "$TERMUX_PKG_CACHEDIR/build-llvm"
	cmake \
		--build "$TERMUX_PKG_CACHEDIR/build-llvm" \
		-j "$TERMUX_MAKE_PROCESSES" \
		--target install

	cmake \
		-G Ninja \
		$BINARYEN_BUILD_ARGS \
		-S "$TERMUX_PKG_CACHEDIR/binaryen-$BINARYEN_COMMIT" \
		-B "$TERMUX_PKG_CACHEDIR/build-binaryen"
	cmake \
		--build "$TERMUX_PKG_CACHEDIR/build-binaryen" \
		-j "$TERMUX_MAKE_PROCESSES" \
		--target install
}

termux_step_make_install() {
	# skip using Makefile which does host npm install, tar archive and extract steps
	rm -fr "$TERMUX_PREFIX/lib/emscripten"
	./tools/install.py "$TERMUX_PREFIX/lib/emscripten"

	# first run generates .emscripten and exits immediately
	./emcc
	sed -i .emscripten -e "s|'EMSCRIPTEN'.*|'EMSCRIPTEN', '$TERMUX_PREFIX/lib/emscripten')) # directory|"
	sed -i .emscripten -e "s|'LLVM'.*|'LLVM', '$TERMUX_PREFIX/lib/emscripten-llvm/bin')) # directory|"
	sed -i .emscripten -e "s|'BINARYEN'.*|'BINARYEN', '$TERMUX_PREFIX/lib/emscripten-binaryen')) # directory|"
	sed -i .emscripten -e "s|'NODE'.*|'NODE', '$TERMUX_PREFIX/bin/node')) # executable|"
	install -Dm644 "$TERMUX_PKG_SRCDIR/.emscripten" "$TERMUX_PREFIX/lib/emscripten/.emscripten"

	# https://github.com/emscripten-core/emscripten/issues/9098 (fixed in 2.0.17)
	cat <<- EOF > "$TERMUX_PKG_TMPDIR/emscripten.sh"
	#!$TERMUX_PREFIX/bin/sh
	export PATH=\$PATH:$TERMUX_PREFIX/lib/emscripten
	EOF
	install -Dm644 "$TERMUX_PKG_TMPDIR/emscripten.sh" "$TERMUX_PREFIX/etc/profile.d/emscripten.sh"

	# remove unneeded files
	for tool in clang-{check,cl,cpp,extdef-mapping,format,func-mapping,import-test,offload-bundler,refactor,rename,scan-deps} \
		lld-link ld.lld ld64.lld llvm-lib ld64.lld.darwin{new,old}; do
		rm -f "$TERMUX_PREFIX/lib/emscripten-llvm/bin/$tool"
	done
	rm -f $TERMUX_PREFIX/lib/emscripten-llvm/lib/libclang.so*
	rm -fr "$TERMUX_PREFIX/lib/emscripten-llvm/share"

	# add useful tools not installed by LLVM_INSTALL_TOOLCHAIN_ONLY=ON
	for tool in FileCheck llc llvm-{as,dis,link,mc,nm,objdump,readobj,size,dwarfdump,dwp} opt; do
		install -Dm755 "$TERMUX_PKG_CACHEDIR/build-llvm/bin/$tool" "$TERMUX_PREFIX/lib/emscripten-llvm/bin/$tool"
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
	#!$TERMUX_PREFIX/bin/sh
	echo 'Running "npm ci --no-optional" in $TERMUX_PREFIX/lib/emscripten ...'
	cd "$TERMUX_PREFIX/lib/emscripten"
	npm ci --no-optional
	echo
	echo 'Post-install notice:'
	echo 'If this is the first time installing Emscripten,'
	echo 'please start a new session to take effect.'
	echo 'If you are upgrading, you may want to clear the'
	echo 'cache by running the command below to fix issues.'
	echo '"emcc --clear-cache"'
	EOF

	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	case "\$1" in
	purge|remove)
		rm -fr "$TERMUX_PREFIX/lib/emscripten"
	esac
	EOF
}
