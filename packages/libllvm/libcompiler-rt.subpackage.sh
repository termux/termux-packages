TERMUX_SUBPKG_DESCRIPTION="Compiler runtime libraries for clang"
TERMUX_SUBPKG_INCLUDE="
include/fuzzer/FuzzedDataProvider.h
include/orc/
include/profile/
include/sanitizer/
include/xray/
lib/clang/*/bin/asan_device_setup
lib/clang/*/bin/hwasan_symbolize
lib/clang/*/lib/linux/
lib/clang/*/share/asan_ignorelist.txt
lib/clang/*/share/cfi_ignorelist.txt
lib/clang/*/share/hwasan_ignorelist.txt
share/libalpm/hooks/update-libcompiler-rt.hook
share/libalpm/scripts/update-libcompiler-rt
"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS=libc++
# file include/fuzzer/FuzzedDataProvider.h is now in libcompiler-rt instead of libllvm
TERMUX_SUBPKG_CONFLICTS="libllvm (<< 21.1.3), ndk-multilib (<< 23b-6)"

termux_step_create_subpkg_debscripts() {
	local RT_OPT_DIR=$TERMUX_PREFIX/opt/ndk-multilib/cross-compiler-rt
	local RT_PATH=$TERMUX_PREFIX/lib/clang/$LLVM_MAJOR_VERSION/lib/linux

	cat <<- EOF > ./triggers
	interest-noawait $RT_OPT_DIR
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	if [[ -e "$RT_OPT_DIR" ]]; then
	    find $RT_OPT_DIR -type f ! -name "lib*-$TERMUX_ARCH-*" -exec ln -sf "{}" $RT_PATH \;
	fi
	exit 0
	EOF
	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		echo "post_install" > postupg
	fi

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	find $RT_PATH -type l ! -name "lib*-$TERMUX_ARCH-*" -exec rm -rf "{}" \;
	exit 0
	EOF
}
