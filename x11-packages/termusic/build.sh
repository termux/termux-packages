TERMUX_PKG_HOMEPAGE=https://github.com/tramhao/termusic
TERMUX_PKG_DESCRIPTION="Terminal Music and Podcast Player written in Rust"
TERMUX_PKG_LICENSE="GPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE_GPLv3, LICENSE_MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.2"
TERMUX_PKG_SRCURL="https://github.com/tramhao/termusic/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=661e1c39135f6eeb01cb6df199b8dcdd902ac456e96bd204ea4fda7ec6ae41ef
TERMUX_PKG_DEPENDS="alsa-lib, glib, gstreamer, gst-plugins-base, gst-plugins-good, mpv | mpv-x"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_rust

	export BINDGEN_EXTRA_CLANG_ARGS="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
	case "${TERMUX_ARCH}" in
	arm) BINDGEN_EXTRA_CLANG_ARGS+=" --target=arm-linux-androideabi${TERMUX_PKG_API_LEVEL}" ;;
	*) BINDGEN_EXTRA_CLANG_ARGS+=" --target=${TERMUX_ARCH}-linux-android${TERMUX_PKG_API_LEVEL}" ;;
	esac
	local env_name=BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME//-/_}
	export "$env_name"="$BINDGEN_EXTRA_CLANG_ARGS"

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cpal \
		-exec rm -rf '{}' \;

	find ./vendor/cpal -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e 's|"linux"|"android"|g'

	cat >> Cargo.toml <<-'EOF'

	[patch.crates-io]
	cpal = { path = "./vendor/cpal" }
	EOF
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--features cover,all-backends,rusty-soundtouch,rusty-libopus \
		--all
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" \
		"target/$CARGO_TARGET_NAME/release/termusic" \
		"target/$CARGO_TARGET_NAME/release/termusic-server"
}
