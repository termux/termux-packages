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

	cat <<- EOF > ./triggers
	interest-noawait $RT_OPT_DIR
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	find $RT_PATH -type l ! -name "libclang_rt*$TERMUX_ARCH*" -exec rm -rf "{}" \;
	if [ -e $RT_OPT_DIR ]; then
	    find $RT_OPT_DIR -type f ! -name "libclang_rt*$TERMUX_ARCH*" -exec ln -sf "{}" $RT_PATH \;
	fi
	exit 0
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	find $RT_PATH -type l ! -name "libclang_rt*$TERMUX_ARCH*" -exec rm -rf "{}" \;
	exit 0
	EOF
}
