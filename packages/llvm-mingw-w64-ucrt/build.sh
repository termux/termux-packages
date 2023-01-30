TERMUX_PKG_HOMEPAGE=https://www.mingw-w64.org/
TERMUX_PKG_DESCRIPTION="MinGW-w64 runtime for LLVM-MinGW"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION=20220906
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/llvm-mingw/releases/download/$TERMUX_PKG_VERSION/llvm-mingw-$TERMUX_PKG_VERSION-ucrt-ubuntu-18.04-x86_64.tar.xz
TERMUX_PKG_SHA256=ee00708bdd65eeaa88d5fa89ad7e3fa1d6bae8093ee4559748e431e55f7568ec
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/opt/llvm-mingw-w64
	mv $TERMUX_PKG_SRCDIR/{aarch64,armv7,i686,x86_64,generic}-w64-mingw32 $TERMUX_PREFIX/opt/llvm-mingw-w64
}

termux_step_install_license() {
	# Runtimes are consist of runtimes libraries from mingw-w64 and libunwind/libc++ from LLVM
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME

	# Install the license of mingw-w64 and mingw-w64-runtimes
	local _file
	for _file in $TERMUX_PREFIX/opt/llvm-mingw-w64/aarch64-w64-mingw32/share/mingw32/*; do
		cp $_file $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
	done

	# Install the license of LLVM
	cp $TERMUX_PKG_SRCDIR/LICENSE.TXT $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE-LLVM.TXT
}
