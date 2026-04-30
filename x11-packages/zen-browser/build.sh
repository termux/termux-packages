TERMUX_PKG_HOMEPAGE=https://zen-browser.app
TERMUX_PKG_DESCRIPTION="Zen is a firefox-based browser with the aim of pushing your productivity to a new level!"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@sabamdarif"
TERMUX_PKG_VERSION="1.19.11b"
TERMUX_PKG_SRCURL="https://github.com/zen-browser/desktop/releases/download/${TERMUX_PKG_VERSION}/zen.source.tar.zst"
TERMUX_PKG_SHA256=cec014292d387b457fcfe232cedfe1e367528c89a699faf5b412f644242dff0c
# ffmpeg and pulseaudio are dependencies through dlopen(3):
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libandroid-spawn, libc++, libcairo, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, libxtst, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures, libice, libsm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	local f="media/ffvpx/config_unix_aarch64.h"
	echo "Applying sed substitution to ${f}"
	sed -E '/^#define (CONFIG_LINUX_PERF|HAVE_SYSCTL) /s/1$/0/' -i ${f}

	# Update Cargo.toml to use the patched cc
	sed -i 's|^\(\[patch\.crates-io\]\)$|\1\ncc = { path = "third_party/rust/cc" }|g' \
		Cargo.toml
	(
		termux_setup_rust
		cargo update -p cc
	)
}

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_rust

	if [ "$TERMUX_DEBUG_BUILD" = false ]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C debuginfo=1"
	fi

	cargo install cbindgen

	export HOST_CC=$(command -v clang)
	export HOST_CXX=$(command -v clang++)

	export BINDGEN_CFLAGS="--target=$CCTERMUX_HOST_PLATFORM --sysroot=$TERMUX_STANDALONE_TOOLCHAIN/sysroot"
	local env_name=BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export $env_name="$BINDGEN_CFLAGS"

	CXXFLAGS+=" -U__ANDROID__ -D_LIBCPP_HAS_NO_C11_ALIGNED_ALLOC"
	LDFLAGS+=" -landroid-shmem -landroid-spawn -llog"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		# For symbol android_getCpuFeatures
		LDFLAGS+=" -l:libndk_compat.a"
	fi
}

termux_step_configure() {
	if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
		termux_step_pre_configure
		cd $TERMUX_PKG_SRCDIR
	fi

	sed \
		-e "s|@TERMUX_HOST_PLATFORM@|${TERMUX_HOST_PLATFORM}|" \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|" \
		-e "s|@CARGO_TARGET_NAME@|${CARGO_TARGET_NAME}|" \
		-e "s|@TERMUX_PKG_VERSION@|${TERMUX_PKG_VERSION}|" \
		"$TERMUX_PKG_BUILDER_DIR/mozconfig.cfg" >.mozconfig

	./mach configure
}

termux_step_make() {
	./mach build -j "$TERMUX_PKG_MAKE_PROCESSES"
	./mach buildsymbols
}

termux_step_make_install() {
	./mach install

	# Install the desktop file
	sed "s|@TERMUX_PKG_NAME@|${TERMUX_PKG_NAME}|g" \
		"${TERMUX_PKG_BUILDER_DIR}/${TERMUX_PKG_NAME}.desktop.in" >"${TERMUX_PKG_NAME}.desktop"
	install -Dm644 "${TERMUX_PKG_NAME}.desktop" "${TERMUX_PREFIX}/share/applications/${TERMUX_PKG_NAME}.desktop"

	# Install icons from the source branding directory
	local i theme=release
	for i in 16 32 48 64 128; do
		install -Dvm644 "browser/branding/$theme/default$i.png" \
			"$TERMUX_PREFIX/share/icons/hicolor/${i}x${i}/apps/$TERMUX_PKG_NAME.png"
		# Also replace the internal chrome icons
		install -Dvm644 "browser/branding/$theme/default$i.png" \
			"$TERMUX_PREFIX/lib/$TERMUX_PKG_NAME/browser/chrome/icons/default/default$i.png"
	done
	install -Dvm644 "browser/branding/$theme/content/about-logo.png" \
		"$TERMUX_PREFIX/share/icons/hicolor/192x192/apps/$TERMUX_PKG_NAME.png"
	install -Dvm644 "browser/branding/$theme/content/about-logo@2x.png" \
		"$TERMUX_PREFIX/share/icons/hicolor/384x384/apps/$TERMUX_PKG_NAME.png"
	install -Dvm644 "browser/branding/$theme/content/about-logo.svg" \
		"$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/$TERMUX_PKG_NAME.svg"
}

termux_step_post_make_install() {
	local r=$("${READELF}" -d "${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}")
	if [[ -n "$(echo "${r}" | grep "(RELR)")" ]]; then
		termux_error_exit "DT_RELR is unsupported on Android 8.x and older\n${r}"
	fi
}
