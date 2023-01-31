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
	interest-noawait $RT_OPT_DIR $LLVM_MINGW_RT_OPT_DIR
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "triggered" -a "\$2" = "$LLVM_MINGW_RT_OPT_DIR" ]; then
	    ln -sf $LLVM_MINGW_RT_OPT_DIR/windows $LLVM_MINGW_RT_PATH
	    exit 0
	fi

	find $RT_PATH -type l ! -name "libclang_rt*$TERMUX_ARCH*" -exec rm -rf "{}" \;
	if [ -e $RT_OPT_DIR ]; then
	    find $RT_OPT_DIR -type f ! -name "libclang_rt*$TERMUX_ARCH*" -exec ln -sf "{}" $RT_PATH \;
	fi
	exit 0
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "triggered" -a "\$2" = "$LLVM_MINGW_RT_OPT_DIR" ]; then
	    rm -f $LLVM_MINGW_RT_PATH
	    exit 0
	fi

	find $RT_PATH -type l ! -name "libclang_rt*$TERMUX_ARCH*" -exec rm -rf "{}" \;
	exit 0
	EOF
}
