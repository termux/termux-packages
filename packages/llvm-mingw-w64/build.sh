TERMUX_PKG_HOMEPAGE=https://github.com/mstorsjo/llvm-mingw
TERMUX_PKG_DESCRIPTION="MinGW-w64 toolchain based on LLVM"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION="20251007"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/llvm-mingw/releases/download/${TERMUX_PKG_VERSION}/llvm-mingw-${TERMUX_PKG_VERSION}-ucrt-ubuntu-22.04-x86_64.tar.xz
TERMUX_PKG_SHA256=ee1c1f3e4a584f231b1d664eb1f4b9d9f7cae133b64b55dae749f50969cef958
TERMUX_PKG_AUTO_UPDATE=false
_LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)
_LLVM_MAJOR_VERSION_NEXT=$((_LLVM_MAJOR_VERSION + 1))
TERMUX_PKG_DEPENDS="clang (<< ${_LLVM_MAJOR_VERSION_NEXT}), llvm (<< ${_LLVM_MAJOR_VERSION_NEXT}), llvm-tools (<< ${_LLVM_MAJOR_VERSION_NEXT})"
TERMUX_PKG_RECOMMENDS="llvm-mingw-w64-tools"
TERMUX_PKG_CONFLICTS="mingw-w64"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_NO_OPENMP_CHECK=true

termux_step_configure() {
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", llvm-mingw-w64-libcompiler-rt, llvm-mingw-w64-ucrt"
}

termux_step_make_install() {
	# Install compier-rt libraries
	rm -rf "$TERMUX_PREFIX/lib/clang/$_LLVM_MAJOR_VERSION/lib/windows"
	mkdir -p "$TERMUX_PREFIX/lib/clang/$_LLVM_MAJOR_VERSION/lib/windows"
	mv "$TERMUX_PKG_SRCDIR/lib/clang/$_LLVM_MAJOR_VERSION/lib/windows" "$TERMUX_PREFIX/lib/clang/$_LLVM_MAJOR_VERSION/lib/"

	# Install ucrt libraries
	mkdir -p "$TERMUX_PREFIX/opt/llvm-mingw-w64"
	rm -rf "$TERMUX_PREFIX/opt/llvm-mingw-w64"/{aarch64,armv7,i686,x86_64,generic}-w64-mingw32
	mv "$TERMUX_PKG_SRCDIR"/{aarch64,armv7,i686,x86_64,generic}-w64-mingw32 "$TERMUX_PREFIX/opt/llvm-mingw-w64"

	# Install the toolchain binaries
	rm -rf "$TERMUX_PREFIX/opt/llvm-mingw-w64/bin"
	mkdir -p "$TERMUX_PREFIX/opt/llvm-mingw-w64/bin"
	# shellcheck disable=SC2164
	cd "$TERMUX_PKG_SRCDIR/bin"

	# These files are packaged in llvm-mingw-w64-tools
	rm ./*widl gendef

	# Do not package lldb
	rm ./*lldb*

	# On Termux, use the wrapper script rather than the wrapper binary
	rm ./*wrapper
	rm ./*wrapper.sh.orig || true

	# Install config files
	mv ./mingw32-common.cfg "$TERMUX_PREFIX/opt/llvm-mingw-w64/bin"
	mv ./{aarch64,armv7,i686,x86_64}*.cfg "$TERMUX_PREFIX/opt/llvm-mingw-w64/bin"

	# Install prefixed scripts
	mv ./{aarch64,armv7,i686,x86_64}* "$TERMUX_PREFIX/opt/llvm-mingw-w64/bin"
	mv ./*wrapper.sh "$TERMUX_PREFIX/opt/llvm-mingw-w64/bin"

	# Symlinks clang, lld and llvm tools
	local _tool _toolname
	for _tool in ./*; do
		_toolname="$(basename "$_tool")"
		ln -sfr "$TERMUX_PREFIX/bin/$_toolname" "$TERMUX_PREFIX/opt/llvm-mingw-w64/bin"
	done

	# Symlinks prefixed scripts to $PREFIX/bin
	for _tool in "$TERMUX_PREFIX/opt/llvm-mingw-w64/bin"/{aarch64,armv7,i686,x86_64}-w64-mingw32*; do
		if [[ ! -e "$TERMUX_PREFIX/bin/$(basename "$_tool")" ]]; then
			ln -sfr "$_tool" "$TERMUX_PREFIX/bin/$(basename "$_tool")"
		fi
	done
}

termux_step_install_license() {
	# Install the LICENSE of llvm-mingw-w64-libcompiler-rt
	mkdir -p "$TERMUX_PREFIX/share/doc/llvm-mingw-w64-libcompiler-rt"
	cp "$TERMUX_PKG_SRCDIR/LICENSE.TXT" "$TERMUX_PREFIX/share/doc/llvm-mingw-w64-libcompiler-rt/"

	# Runtimes are consist of runtimes libraries from mingw-w64 and libunwind/libc++ from LLVM
	mkdir -p "$TERMUX_PREFIX/share/doc/llvm-mingw-w64-ucrt"

	# Install the license of mingw-w64 and mingw-w64-runtimes
	local _file
	for _file in "$TERMUX_PREFIX"/opt/llvm-mingw-w64/aarch64-w64-mingw32/share/mingw32/*; do
		cp "$_file" "$TERMUX_PREFIX/share/doc/llvm-mingw-w64-ucrt/"
	done

	# Install the license of libc++ and libunwind
	cp "$TERMUX_PKG_SRCDIR/LICENSE.TXT" "$TERMUX_PREFIX/share/doc/llvm-mingw-w64-ucrt/LICENSE-LLVM.TXT"

	# Install the license of the llvm-mingw-w64 toolchain
	mkdir -p "$TERMUX_PREFIX/share/doc/llvm-mingw-w64"
	cp "$TERMUX_PKG_SRCDIR/LICENSE.TXT" "$TERMUX_PREFIX/share/doc/llvm-mingw-w64/copyright"
}
