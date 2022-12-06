TERMUX_PKG_HOMEPAGE=https://gif.ski/
TERMUX_PKG_DESCRIPTION="GIF encoder based on libimagequant"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ImageOptim/gifski/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9c06e0124a5bde4d70fe44cc8be52ffc9b9099548fc34cac1db43c4a6ff8783c
TERMUX_PKG_DEPENDS="ffmpeg"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--features video
"

termux_step_post_get_source() {
	rm -f Cargo.lock
}

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local p=$TERMUX_PKG_BUILDER_DIR/rust-ffmpeg-sys-1-build.rs.diff
	local d
	for d in $CARGO_HOME/git/checkouts/rust-ffmpeg-sys-1-*/*; do
		sed 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' ${p} \
			| patch --silent -p1 -d ${d} || :
	done
}

termux_step_make_install() {
	cargo install \
		--jobs $TERMUX_MAKE_PROCESSES \
		--path . \
		--force \
		--locked \
		--no-track \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
