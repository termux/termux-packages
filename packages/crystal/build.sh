TERMUX_PKG_HOMEPAGE=https://crystal-lang.org
TERMUX_PKG_DESCRIPTION="Fast and statically typed, compiled language with Ruby-like syntax"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@HertzDevil"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=git+https://github.com/crystal-lang/crystal
TERMUX_PKG_AUTO_UPDATE=true
_LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)
_LLVM_MAJOR_VERSION_NEXT=$((_LLVM_MAJOR_VERSION + 1))
TERMUX_PKG_DEPENDS="libevent, libgc, libgmp, libiconv, libllvm (<< $_LLVM_MAJOR_VERSION_NEXT), libxml2, libyaml, openssl, pcre2, zlib"
TERMUX_PKG_RECOMMENDS="clang, libffi, make, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	local SHARDS_VERSION=0.17.3
	local MOLINILLO_VERSION=0.2.0
	local MOLINILLO_URL=https://github.com/crystal-lang/crystal-molinillo/archive/v$MOLINILLO_VERSION.tar.gz

	termux_setup_crystal

	CC="$CC_FOR_BUILD" LLVM_CONFIG="$TERMUX_PREFIX/bin/llvm-config" \
		make crystal target=$TERMUX_HOST_PLATFORM release=1 FLAGS=-Dwithout_iconv

	$CC .build/crystal.o -o .build/crystal $LDFLAGS -rdynamic src/llvm/ext/llvm_ext.o \
		$("$TERMUX_PREFIX/bin/llvm-config" --libs --system-libs --ldflags 2> /dev/null) \
		-lstdc++ -lpcre2-8 -lm -lgc -levent -ldl

	git clone --depth 1 --single-branch \
		--branch v$SHARDS_VERSION \
		https://github.com/crystal-lang/shards.git

	cd shards
	mkdir -p lib/molinillo
	curl -L "$MOLINILLO_URL" | tar -xzf - -C lib/molinillo --strip-components=1
	CC="$CC_FOR_BUILD" make SHARDS=false release=1 \
		FLAGS="--cross-compile --target aarch64-linux-android -Dwithout_iconv"
	$CC bin/shards.o -o bin/shards $LDFLAGS -rdynamic \
		-lyaml -lpcre2-8 -lgc -levent -ldl
}

termux_step_make_install() {
	make install PREFIX="$TERMUX_PREFIX"
	cd shards && make install PREFIX="$TERMUX_PREFIX"
}
