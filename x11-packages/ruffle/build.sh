TERMUX_PKG_HOMEPAGE=https://ruffle.rs/
TERMUX_PKG_DESCRIPTION="A Flash Player emulator written in Rust"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT_DATE="2026-03-20"
TERMUX_PKG_VERSION="0.0.1-nightly-$_COMMIT_DATE"
TERMUX_PKG_SRCURL=https://github.com/ruffle-rs/ruffle/archive/refs/tags/nightly-${_COMMIT_DATE}.tar.gz
TERMUX_PKG_SHA256=8a5a6d73acd7cecaa2213cd551313c144c12707d6b6e54ebeb6f446abc6df1fe
TERMUX_PKG_DEPENDS="alsa-lib, alsa-plugins, fontconfig, gtk3, openh264"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_pkg_auto_update() {
	local latest_tags
	latest_tags="$(termux_github_api_get_tag)"

	local latest_commit_date=$(echo "${latest_tags}" | sed -e "s/nightly-//")
	local latest_version="0.0.1-nightly-$latest_commit_date"

	local current_date_epoch=$(date "+%s")
	local _COMMIT_DATE_epoch=$(date -d "${_COMMIT_DATE}" "+%s")
	local current_date_diff=$(((current_date_epoch-_COMMIT_DATE_epoch)/(60*60*24)))
	local cooldown_days=14
	if [[ "${current_date_diff}" -lt "${cooldown_days}" ]]; then
		cat <<- EOL
		INFO: Queuing updates since last push
		Cooldown (days) = ${cooldown_days}
		Days since	  = ${current_date_diff}
		EOL
		return
	fi

	if ! dpkg --compare-versions "${latest_version}" gt "${TERMUX_PKG_VERSION}"; then
		termux_error_exit "
		ERROR: Resulting latest version is not counted as an update!
		Latest version  = ${latest_version}
		Current version = ${TERMUX_PKG_VERSION}
		"
	fi

	# unlikely to happen
	if [[ "${latest_commit_date}" -lt "${_COMMIT_DATE}" ]]; then
		cat <<- EOL
		INFO: Upstream is older than current package version
		EOL
		return
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_version}."
		return
	fi

	sed \
		-e "s|^_COMMIT=.*|_COMMIT=${latest_commit}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	termux_pkg_upgrade_version "${latest_version}" --skip-version-check
}

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
