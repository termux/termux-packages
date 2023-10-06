TERMUX_PKG_HOMEPAGE=https://www.llvm.org/
TERMUX_PKG_DESCRIPTION="Compiler runtime libraries for LLVM-MinGW"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION=20231003
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/llvm-mingw/releases/download/$TERMUX_PKG_VERSION/llvm-mingw-$TERMUX_PKG_VERSION-ucrt-ubuntu-20.04-x86_64.tar.xz
TERMUX_PKG_SHA256=df6b9bcfac48c926aa8f6ccd6179ae7b8eeccd9f5fdf4a2c10b601b6b58e4c83
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_make_install() {
	# Install compier-rt libraries
	local LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)
	mkdir -p $TERMUX_PREFIX/lib/clang/$LLVM_MAJOR_VERSION/lib/windows
	mv $TERMUX_PKG_SRCDIR/lib/clang/*/lib/windows $TERMUX_PREFIX/lib/clang/$LLVM_MAJOR_VERSION/lib/
}

termux_step_install_license() {
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	cp $TERMUX_PKG_SRCDIR/LICENSE.TXT $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
}
