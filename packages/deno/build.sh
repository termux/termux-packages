TERMUX_PKG_HOMEPAGE=https://deno.land/
TERMUX_PKG_DESCRIPTION="A modern runtime for JavaScript and TypeScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17.3
TERMUX_PKG_SRCURL=https://github.com/denoland/deno.git
TERMUX_PKG_DEPENDS="libffi"
TERMUX_PKG_BUILD_DEPENDS="librusty-v8"
TERMUX_PKG_BUILD_IN_SRC=true

# Due to dependency on librusty-v8.
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

termux_step_make() {
	termux_setup_rust
	local libdir=target/$CARGO_TARGET_NAME/release/deps
	mkdir -p $libdir
	ln -sf $TERMUX_PREFIX/lib/libffi.so $libdir/
	local libgcc="$($CC -print-libgcc-file-name)"
	echo "INPUT($libgcc -l:libunwind.a)" > $libdir/libgcc.so
	local cmd="cargo build --jobs $TERMUX_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME --release"
	$cmd || :
	ln -sf $TERMUX_PREFIX/lib/librusty_v8.a \
		target/$CARGO_TARGET_NAME/release/gn_out/obj/librusty_v8.a
	$cmd
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/deno
}
