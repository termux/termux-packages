TERMUX_PKG_HOMEPAGE=https://odin-lang.org/
TERMUX_PKG_DESCRIPTION="The Odin programming language"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2024.10
TERMUX_PKG_SRCURL=https://github.com/odin-lang/Odin/archive/refs/tags/dev-${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=00e7a033129006fb339b5514955dc0d7fafa712919db9f32e1a6d5bededb8a19
TERMUX_PKG_DEPENDS="libllvm"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"


# Logic is borrowed from build_odin.sh (https://github.com/odin-lang/Odin/blob/master/build_odin.sh)
termux_step_pre_configure() {
	# llvm-config prints path to static libraries relatively to its own location
	mkdir -p "$TERMUX_PKG_TMPDIR/bin"
	ln -sf "$TERMUX_PREFIX/lib" "$TERMUX_PKG_TMPDIR/lib"
	cp -f "$TERMUX_STANDALONE_TOOLCHAIN/bin/llvm-config" "$TERMUX_PKG_TMPDIR/bin/"

	CPPFLAGS="$CPPFLAGS -DODIN_VERSION_RAW=\"dev-${TERMUX_PKG_VERSION//./-}\""
	if [ "$TERMUX_PKG_API_LEVEL" -lt 28 ]; then
		CPPFLAGS+=" -Daligned_alloc=memalign"
	fi
	CXXFLAGS="$CXXFLAGS -std=c++14"
	DISABLED_WARNINGS="-Wno-switch -Wno-macro-redefined -Wno-unused-value"
	LDFLAGS="$LDFLAGS -pthread -lm -lstdc++"

	if [ -d ".git" ] && [ -n "$(command -v git)" ]; then
		GIT_SHA=$(git show --pretty='%h' --no-patch --no-notes HEAD)
		CPPFLAGS="$CPPFLAGS -DGIT_SHA=\"$GIT_SHA\""
	fi

	LLVM_CONFIG="$TERMUX_PKG_TMPDIR/bin/llvm-config"
	LLVM_VERSION="$($LLVM_CONFIG --version)"
	LLVM_VERSION_MAJOR="$(echo $LLVM_VERSION | awk -F. '{print $1}')"
	LLVM_VERSION_MINOR="$(echo $LLVM_VERSION | awk -F. '{print $2}')"
	LLVM_VERSION_PATCH="$(echo $LLVM_VERSION | awk -F. '{print $3}')"

	CXXFLAGS="$CXXFLAGS $($LLVM_CONFIG --cxxflags --ldflags)"
	LDFLAGS="$LDFLAGS -ldl $($LLVM_CONFIG --libs core native --system-libs --libfiles | sed 's,$TERMUX_PKG_TMPDIR/lib,$TERMUX_PREFIX/lib,g')"
	LDFLAGS="$LDFLAGS -Wl,-rpath=\$ORIGIN"

	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		# Use preferred flag for Arm (ie arm64 / aarch64 / etc)
		EXTRAFLAGS="-O3"
	else
		# Use preferred flag for x86 / amd64
		EXTRAFLAGS="-O3 -march=native"
	fi
}

termux_step_make() {
	$CXX $TERMUX_PKG_SRCDIR/src/main.cpp $TERMUX_PKG_SRCDIR/src/libtommath.cpp $DISABLED_WARNINGS $CPPFLAGS $CXXFLAGS $EXTRAFLAGS $LDFLAGS -o odin
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin odin
}
