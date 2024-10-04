TERMUX_PKG_HOMEPAGE=https://github.com/mstorsjo/llvm-mingw
TERMUX_PKG_DESCRIPTION="MinGW-w64 toolchain based on LLVM"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@licy183"
# Bump llvm-mingw-w64* to the same version in one PR.
TERMUX_PKG_VERSION="20241001"
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/llvm-mingw/releases/download/$TERMUX_PKG_VERSION/llvm-mingw-$TERMUX_PKG_VERSION-ucrt-ubuntu-20.04-x86_64.tar.xz
TERMUX_PKG_SHA256=5ef76d9a772f5896fafb61a1b670bc13e5336692ecdcea2b312a64552d58a1a2
TERMUX_PKG_AUTO_UPDATE=false
_LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)
_LLVM_MAJOR_VERSION_NEXT=$((_LLVM_MAJOR_VERSION + 1))
TERMUX_PKG_DEPENDS="clang (<< ${_LLVM_MAJOR_VERSION_NEXT}), llvm (<< ${_LLVM_MAJOR_VERSION_NEXT}), llvm-tools (<< ${_LLVM_MAJOR_VERSION_NEXT}), llvm-mingw-w64-libcompiler-rt, llvm-mingw-w64-ucrt"
TERMUX_PKG_RECOMMENDS="llvm-mingw-w64-tools"
TERMUX_PKG_CONFLICTS="mingw-w64"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/opt/llvm-mingw-w64/bin
	mkdir -p $TERMUX_PREFIX/opt/llvm-mingw-w64/bin
	cd $TERMUX_PKG_SRCDIR/bin

	# These files are packaged in llvm-mingw-w64-tools
	rm *widl gendef

	# Do not package lldb
	rm *lldb*

	# On Termux, use the wrapper script rather than the wrapper binary
	rm *wrapper
	rm *wrapper.sh.orig

	# Install prefixed scripts
	mv {aarch64,armv7,i686,x86_64}* $TERMUX_PREFIX/opt/llvm-mingw-w64/bin
	mv *wrapper.sh $TERMUX_PREFIX/opt/llvm-mingw-w64/bin

	# Symlinks clang, lld and llvm tools
	local _tool
	for _tool in ./*; do
		local _toolname=$(basename $_tool)
		ln -sr $TERMUX_PREFIX/bin/$_toolname $TERMUX_PREFIX/opt/llvm-mingw-w64/bin
	done

	# Symlinks prefixed scripts to $PREFIX/bin
	for _tool in $TERMUX_PREFIX/opt/llvm-mingw-w64/bin/{aarch64,armv7,i686,x86_64}*; do
		if [ ! -e $TERMUX_PREFIX/bin/"$(basename $_tool)" ]; then
			ln -sr $_tool $TERMUX_PREFIX/bin/"$(basename $_tool)"
		fi
	done
}
