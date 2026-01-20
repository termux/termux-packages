TERMUX_PKG_HOMEPAGE=https://crystal-lang.org
TERMUX_PKG_DESCRIPTION="Fast and statically typed, compiled language with Ruby-like syntax"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@HertzDevil"
TERMUX_PKG_VERSION="1.19.1"
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=git+https://github.com/crystal-lang/crystal
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libevent, libgc, libgmp, libiconv, libllvm (<< $TERMUX_LLVM_NEXT_MAJOR_VERSION), libxml2, libyaml, openssl, pcre2, zlib"
TERMUX_PKG_RECOMMENDS="clang, libffi, make, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

termux_step_make() {
	local SHARDS_VERSION=0.18.0
	local MOLINILLO_VERSION=0.2.0
	local MOLINILLO_URL=https://github.com/crystal-lang/crystal-molinillo/archive/v$MOLINILLO_VERSION.tar.gz
	local MOLINILLO_TARFILE=$TERMUX_PKG_TMPDIR/crystal-molinillo-$MOLINILLO_VERSION.tar.gz
	local MOLINILLO_SHA256=e231cf2411a6a11a1538983c7fb52b19e650acc3338bd3cdf6fdb13d6463861a

	termux_setup_crystal

	CC="$CC_FOR_BUILD" ANDROID_PLATFORM="$TERMUX_PKG_API_LEVEL" LLVM_CONFIG="$TERMUX_PREFIX/bin/llvm-config" \
		make crystal target=$TERMUX_HOST_PLATFORM release=1 FLAGS=-Dwithout_iconv

	$CC .build/crystal.o -o .build/crystal $LDFLAGS -rdynamic \
		$("$TERMUX_PREFIX/bin/llvm-config" --libs --system-libs --ldflags 2> /dev/null) \
		-lstdc++ -lpcre2-8 -lm -lgc -levent -ldl

	git clone --depth 1 --single-branch \
		--branch v$SHARDS_VERSION \
		https://github.com/crystal-lang/shards.git

	cd shards
	mkdir -p lib/molinillo
	termux_download "$MOLINILLO_URL" "$MOLINILLO_TARFILE" "$MOLINILLO_SHA256"
	tar xzf "$MOLINILLO_TARFILE" --strip-components=1 -C lib/molinillo
	CC="$CC_FOR_BUILD" ANDROID_PLATFORM="$TERMUX_PKG_API_LEVEL" \
		make SHARDS=false release=1 \
		FLAGS="--cross-compile --target $TERMUX_HOST_PLATFORM -Dwithout_iconv"
	$CC bin/shards.o -o bin/shards $LDFLAGS -rdynamic \
		-lyaml -lpcre2-8 -lgc -levent -ldl
}

termux_step_make_install() {
	LLVM_CONFIG="$TERMUX_PREFIX/bin/llvm-config" make install PREFIX="$TERMUX_PREFIX"
	cd shards && make install PREFIX="$TERMUX_PREFIX"
}
