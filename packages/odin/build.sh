TERMUX_PKG_HOMEPAGE=https://odin-lang.org/
TERMUX_PKG_DESCRIPTION="The Odin programming language"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2024.10
TERMUX_PKG_SRCURL=https://github.com/odin-lang/Odin/archive/refs/tags/dev-${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=00e7a033129006fb339b5514955dc0d7fafa712919db9f32e1a6d5bededb8a19
TERMUX_PKG_DEPENDS="libllvm"
TERMUX_PKG_BUILD_DEPENDS="clang"


# ```
# [...]/src/gb/gb.h:6754:2: error: "gb_rdtsc not supported"
# #error "gb_rdtsc not supported"
#  ^
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
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

	LLVM_CONFIG="llvm-config"
	LLVM_VERSION="$($LLVM_CONFIG --version)"
	LLVM_VERSION_MAJOR="$(echo $LLVM_VERSION | awk -F. '{print $1}')"
	LLVM_VERSION_MINOR="$(echo $LLVM_VERSION | awk -F. '{print $2}')"
	LLVM_VERSION_PATCH="$(echo $LLVM_VERSION | awk -F. '{print $3}')"

	CXXFLAGS="$CXXFLAGS $($LLVM_CONFIG --cxxflags --ldflags)"
	LDFLAGS="$LDFLAGS -ldl $($LLVM_CONFIG --libs core native --system-libs --libfiles)"
	LDFLAGS="$LDFLAGS -Wl,-rpath=\$ORIGIN"

	EXTRAFLAGS="-O3 -mcpu=native"
}

termux_step_make() {
	$CXX src/main.cpp src/libtommath.cpp $DISABLED_WARNINGS $CPPFLAGS $CXXFLAGS $EXTRAFLAGS $LDFLAGS -o odin
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin odin
}
