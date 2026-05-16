TERMUX_PKG_HOMEPAGE=https://ruffle.rs/
TERMUX_PKG_DESCRIPTION="A Flash Player emulator written in Rust"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.0"
TERMUX_PKG_SRCURL="https://github.com/ruffle-rs/ruffle/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f14fa41476fcf509712a547f150f269caf1f410c11ce6a8d72641e233fd78f4c
TERMUX_PKG_DEPENDS="alsa-lib, alsa-plugins, fontconfig, gtk3, openh264"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/arboard \
		! -wholename ./vendor/cpal \
		! -wholename ./vendor/fontdb \
		! -wholename ./vendor/rfd \
		! -wholename ./vendor/smithay-client-toolkit \
		! -wholename ./vendor/wayland-cursor \
		! -wholename ./vendor/winit \
		! -wholename ./vendor/wgpu \
		! -wholename ./vendor/wgpu-hal \
		! -wholename ./vendor/x11rb-protocol \
		! -wholename ./vendor/xkbcommon-dl \
		-exec rm -rf '{}' \;

	local patch dir
	patch="$TERMUX_PKG_BUILDER_DIR/wayland-cursor-no-shm.diff"
	dir="vendor/wayland-cursor"
	echo "Applying patch: $patch"
	patch --silent -p1 -d "$dir" < "$patch"

	patch="$TERMUX_PKG_BUILDER_DIR/smithay-client-toolkit-no-shm.diff"
	dir="vendor/smithay-client-toolkit"
	echo "Applying patch: $patch"
	patch --silent -p1 -d "$dir" < "${patch}"

	patch="$TERMUX_PKG_BUILDER_DIR/fontdb-load-fonts.diff"
	dir="vendor/fontdb"
	echo "Applying patch: $patch"
	patch --silent -p1 -d "$dir" < "${patch}"

	find vendor/{arboard,cpal,rfd,smithay-client-toolkit,wayland-cursor,winit,wgpu,wgpu-hal,x11rb-protocol,xkbcommon-dl} -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e 's|"linux"|"android"|g' \
		-e "s|libxkbcommon.so.0|libxkbcommon.so|g" \
		-e "s|libxkbcommon-x11.so.0|libxkbcommon-x11.so|g" \
		-e "s|libxcb.so.1|libxcb.so|g" \
		-e "s|/tmp|$TERMUX_PREFIX/tmp|g"

	patch="$TERMUX_PKG_BUILDER_DIR/wgpu-hal-no-khr-display.diff"
	dir="vendor/wgpu-hal"
	echo "Applying patch: $patch"
	patch --silent -p1 -d "$dir" < "${patch}"

	find . -type f -print0 | \
		xargs -0 sed -i \
		-e 's|target_os = "linux"|any(target_os = "linux", target_os = "android")|g'

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	for crate in arboard cpal fontdb rfd smithay-client-toolkit wayland-cursor winit wgpu wgpu-hal x11rb-protocol xkbcommon-dl; do
		echo "$crate = { path = \"./vendor/$crate\" }" >> Cargo.toml
	done
}

termux_step_make() {
	termux_setup_rust

	cargo build \
		--package ruffle_desktop \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME \
		--release
}

termux_step_make_install() {
	install -Dm755 \
		$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/ruffle_desktop \
		$TERMUX_PREFIX/bin/ruffle

	install -Dm0644 \
		-t "$TERMUX_PREFIX"/share/doc/"$TERMUX_PKG_NAME" \
		"$TERMUX_PKG_BUILDDIR"/README.md

	local s
	for s in 16x16 32x32 128x128 256x256 512x512; do
		install -Dm0644 \
			"desktop/assets/Assets.xcassets/RuffleMacIcon.iconset/icon_$s.png" \
			"$TERMUX_PREFIX/share/icons/hicolor/$s/apps/ruffle.png"
	done

	install -d "$TERMUX_PREFIX/share/applications/"
	cat > "$TERMUX_PREFIX/share/applications/ruffle.desktop" << _EOD
[Desktop Entry]
Type=Application
Name=Ruffle
GenericName=Ruffle
Comment=Player for using content created on the Adobe Flash platform
Exec=ruffle
Icon=ruffle
Terminal=false
StartupNotify=false
Categories=Audio;AudioVideo;Graphics;GTK;Player;Video;Viewer;
MimeType=application/x-shockwave-flash;
_EOD
}
