TERMUX_PKG_HOMEPAGE=https://deno.land/
TERMUX_PKG_DESCRIPTION="A modern runtime for JavaScript and TypeScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=1259a3f48c00e95a8bb0964e4dabfa769a20bcde
_COMMIT_DATE=2022.01.19
TERMUX_PKG_VERSION=1.17.3p${_COMMIT_DATE//./}
TERMUX_PKG_SRCURL=https://github.com/denoland/deno.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="libffi"
#TERMUX_PKG_BUILD_DEPENDS="librusty-v8"
TERMUX_PKG_BUILD_IN_SRC=true

# Due to dependency on librusty-v8.
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$_COMMIT_DATE" ]; then
		echo -n "ERROR: The specified commit date \"$_COMMIT_DATE\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	git submodule update --init --recursive
}

termux_step_make() {
	termux_setup_rust
	local libdir=target/$CARGO_TARGET_NAME/release/deps
	mkdir -p $libdir
	ln -sf $TERMUX_PREFIX/lib/libffi.so $libdir/
	local libgcc="$($CC -print-libgcc-file-name)"
	echo "INPUT($libgcc -l:libunwind.a)" > $libdir/libgcc.so
	local cmd="cargo build --jobs $TERMUX_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME --release"
	#$cmd || :
	#ln -sf $TERMUX_PREFIX/lib/librusty_v8.a \
	#	target/$CARGO_TARGET_NAME/release/gn_out/obj/librusty_v8.a
	$cmd
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/deno
}
