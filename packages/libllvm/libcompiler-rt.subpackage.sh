TERMUX_SUBPKG_DESCRIPTION="Compiler runtime libraries for clang"
TERMUX_SUBPKG_INCLUDE="
lib/clang/*/bin/asan_device_setup
lib/clang/*/bin/hwasan_symbolize
lib/clang/*/include/fuzzer/FuzzedDataProvider.h
lib/clang/*/include/profile/InstrProfData.inc
lib/clang/*/include/sanitizer/
lib/clang/*/include/xray/
lib/clang/*/lib/linux/
lib/clang/*/share/asan_ignorelist.txt
lib/clang/*/share/cfi_ignorelist.txt
lib/clang/*/share/hwasan_ignorelist.txt
"
TERMUX_SUBPKG_CONFLICTS="ndk-multilib (<< 23b-6)"

termux_step_create_subpkg_debscripts() {
	local RT_OPT_DIR=$TERMUX_PREFIX/opt/ndk-multilib/cross-compiler-rt
	local RT_PATH=$TERMUX_PREFIX/lib/clang/$TERMUX_PKG_VERSION/lib/linux
	local LLVM_MINGW_RT_OPT_DIR=$TERMUX_PREFIX/opt/llvm-mingw-w64/opt/compiler-rt
	local LLVM_MINGW_RT_PATH=$TERMUX_PREFIX/lib/clang/$TERMUX_PKG_VERSION/lib/windows

	cat <<- EOF > ./triggers
	interest-noawait $RT_OPT_DIR
	interest-noawait $LLVM_MINGW_RT_OPT_DIR
	EOF

	# This script will do the following jobs: 
	# - 1. Copy files from ndk-multilib if it is inited.
	# - 2. Symlink folder from llvm-libcompiler-rt if it is inited.
	# This script will run in the following cases: 
	# - 1. After `libcompiler-rt` is inited, with params `configure` and version number
	# - 2. After `ndk-multilib` is inited, with params `triggered` and `$RT_OPT_DIR`
	# - 3. After `llvm-libcompiler-rt` is inited, with params `triggered` and `$LLVM_MINGW_RT_OPT_DIR`
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	find $RT_PATH -type l ! -name "libclang_rt*$TERMUX_ARCH*" -exec rm -rf "{}" \;
	if [ -e $RT_OPT_DIR ]; then
	    find $RT_OPT_DIR -type f ! -name "libclang_rt*$TERMUX_ARCH*" -exec ln -sf "{}" $RT_PATH \;
	fi

	rm -f $LLVM_MINGW_RT_PATH
	if [ -e $LLVM_MINGW_RT_OPT_DIR ]; then
	    ln -sf $LLVM_MINGW_RT_OPT_DIR/windows $LLVM_MINGW_RT_PATH
	fi

	exit 0
	EOF

	# This script will do the following jobs: 
	# - 1. Remove all files copied by this script if `libcompiler-rt` is being removed.
	# - 2. Remove files from `ndk-multilib` if it is being removed.
	# - 3. Remove the symlink to `llvm-libcompiler-rt` if it is being removed.
	# This script will run in the following cases: 
	# - 1. Before `libcompiler-rt` is removed, with params `configure` and version number
	# - 2. Before `ndk-multilib` is removed, with params `triggered` and `$RT_OPT_DIR`
	# - 3. Before `llvm-libcompiler-rt` is removed, with params `triggered` and `$LLVM_MINGW_RT_OPT_DIR`
	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$2" = "$RT_OPT_DIR" ]; then
	    find $RT_PATH -type l ! -name "libclang_rt*$TERMUX_ARCH*" -exec rm -rf "{}" \;
	    exit 0
	elif [ "\$2" = "$LLVM_MINGW_RT_OPT_DIR" ]; then
	    rm -f $LLVM_MINGW_RT_PATH
	    exit 0
	fi

	find $RT_PATH -type l ! -name "libclang_rt*$TERMUX_ARCH*" -exec rm -rf "{}" \;
	rm -f $LLVM_MINGW_RT_PATH
	exit 0
	fi
	EOF
}
