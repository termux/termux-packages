TERMUX_PKG_HOMEPAGE=https://github.com/xiph/rav1e/
TERMUX_PKG_DESCRIPTION="An AV1 encoder library focused on speed and safety"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.1
TERMUX_PKG_SRCURL=https://github.com/xiph/rav1e/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7b3060e8305e47f10b79f3a3b3b6adc3a56d7a58b2cb14e86951cc28e1b089fd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install(){
	termux_setup_rust

	termux_download \
		https://github.com/lu-zero/cargo-c/releases/download/v0.9.5/cargo-c-linux.tar.gz \
		$TERMUX_PKG_CACHEDIR/cargo-c-linux.tar.gz \
		b16717417b5e07f7aabcff1227d94689a8a8bcbcac7df6999135ab86c762066f
	tar -xzf $TERMUX_PKG_CACHEDIR/cargo-c-linux.tar.gz -C $HOME/.cargo/bin

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
