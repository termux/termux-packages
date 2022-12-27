TERMUX_PKG_HOMEPAGE=https://github.com/xiph/rav1e/
TERMUX_PKG_DESCRIPTION="An AV1 encoder library focused on speed and safety"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.2
TERMUX_PKG_SRCURL=https://github.com/xiph/rav1e/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8fe8d80bc80a05ee33113c0ee19779d9c57189e5434c8e1da8f67832461aa089
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_make_install(){
	termux_setup_rust

	termux_download \
		https://github.com/lu-zero/cargo-c/releases/download/v0.9.14/cargo-c-x86_64-unknown-linux-musl.tar.gz \
		$TERMUX_PKG_CACHEDIR/cargo-c-x86_64-unknown-linux-musl.tar.gz \
		3babffbe9316d3ff00957ec19e82ecf07050c5c6ff8d70fe0d17f40db8ff3e56
	tar -xzf $TERMUX_PKG_CACHEDIR/cargo-c-x86_64-unknown-linux-musl.tar.gz -C $HOME/.cargo/bin

	export CARGO_BUILD_TARGET=$CARGO_TARGET_NAME

	cargo fetch \
		--target $CARGO_TARGET_NAME \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	cargo install \
		--jobs $TERMUX_MAKE_PROCESSES \
		--path . \
		--force \
		--locked \
		--no-track \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	# `cargo cinstall` refuses to work with Android
	cargo cbuild \
		--release \
		--prefix $TERMUX_PREFIX \
		--jobs $TERMUX_MAKE_PROCESSES \
		--frozen \
		--target $CARGO_TARGET_NAME \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	cd target/$CARGO_TARGET_NAME/release/
	mkdir -p $TERMUX_PREFIX/include/rav1e/
	cp rav1e.h $TERMUX_PREFIX/include/rav1e/
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig/
	cp rav1e.pc $TERMUX_PREFIX/lib/pkgconfig/
	cp librav1e.a $TERMUX_PREFIX/lib/
	cp librav1e.so $TERMUX_PREFIX/lib/librav1e.so.$TERMUX_PKG_VERSION
	ln -s librav1e.so.$TERMUX_PKG_VERSION \
		$TERMUX_PREFIX/lib/librav1e.so.${TERMUX_PKG_VERSION%%.*}
	ln -s librav1e.so.$TERMUX_PKG_VERSION $TERMUX_PREFIX/lib/librav1e.so
}
