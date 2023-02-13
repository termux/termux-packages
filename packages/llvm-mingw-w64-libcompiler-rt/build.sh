TERMUX_PKG_HOMEPAGE=https://www.llvm.org/
TERMUX_PKG_DESCRIPTION="Compiler runtime libraries for LLVM-MinGW"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION=20220906
# Note: This package should revbump after libllvm gets minor update
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/llvm-mingw/releases/download/$TERMUX_PKG_VERSION/llvm-mingw-$TERMUX_PKG_VERSION-ucrt-ubuntu-18.04-x86_64.tar.xz
TERMUX_PKG_SHA256=ee00708bdd65eeaa88d5fa89ad7e3fa1d6bae8093ee4559748e431e55f7568ec
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_make_install() {
	# Install compier-rt libraries
	local _LLVM_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $TERMUX_PKG_VERSION)
	mkdir -p $TERMUX_PREFIX/lib/clang/$_LLVM_VERSION/lib/windows
	mv $TERMUX_PKG_SRCDIR/lib/clang/*/lib/windows $TERMUX_PREFIX/lib/clang/$_LLVM_VERSION/lib/
}

termux_step_install_license() {
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	cp $TERMUX_PKG_SRCDIR/LICENSE.TXT $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
}
