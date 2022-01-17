TERMUX_PKG_HOMEPAGE=https://github.com/denoland/rusty_v8
TERMUX_PKG_DESCRIPTION="High quality Rust bindings to V8's C++ API"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=2fdcc0c629f5c6c2f251dec4a0f2cb370814dd26
TERMUX_PKG_VERSION=2022.01.13
TERMUX_PKG_SRCURL=https://github.com/denoland/rusty_v8.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	git submodule update --init --recursive
}

termux_step_pre_configure() {
	export V8_FROM_SOURCE=1
	export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib \
		target/$CARGO_TARGET_NAME/release/gn_out/obj/librusty_v8.a
}

termux_step_post_make_install() {
	unset V8_FROM_SOURCE
	unset PKG_CONFIG_PATH
}
