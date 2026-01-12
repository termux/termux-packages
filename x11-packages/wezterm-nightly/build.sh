TERMUX_PKG_HOMEPAGE=https://github.com/wez/wezterm
TERMUX_PKG_DESCRIPTION="GPU-accelerated cross-platform terminal emulator and multiplexer (development branch)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20260109"
TERMUX_PKG_SRCURL=git+https://github.com/wezterm/wezterm
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="fontconfig, freetype, glib, harfbuzz, hicolor-icon-theme, libpng, libssh2, libx11, libxcb, libxkbcommon, openssl, ttf-jetbrains-mono, xdg-utils, xcb-util, xcb-util-image, zlib"
TERMUX_PKG_RECOMMENDS="ncurses, ttf-nerd-fonts-symbols"
TERMUX_PKG_BREAKS="wezterm"
TERMUX_PKG_CONFLICTS="wezterm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local origin_url last_autoupdate
	# Throttle auto updates to once every three weeks
	local update_interval="$((3 * 7 * 86400))"

	# Get the git history
	if origin_url="$(git config --get remote.origin.url)"; then
		git fetch --quiet "${origin_url}" || {
			echo "WARN: Unable to fetch '${origin_url}'"
			echo "WARN: Skipping auto update for '$TERMUX_PKG_NAME'"
			return
		}
	fi

	# When was `wezterm` last autoupdated? (Unix epoch timestamp)
	last_autoupdate="$(
		git log \
		--author="Termux Github Actions <contact@termux.dev>" \
		-n1 \
		--pretty=format:%at \
		-- "$TERMUX_PKG_BUILDER_DIR/build.sh"
	)"


	if (( last_autoupdate > EPOCHSECONDS - update_interval )); then
		local t days hrs mins secs
		(( t = EPOCHSECONDS - last_autoupdate, days = t/86400, t %= 86400, secs= t%60, t /= 60, mins = t%60, hrs = t/60 ))

		printf 'INFO: Last updated %dd%dh%02dm%02ds ago.\n' "$days" "$hrs" "$mins" "$secs"
		printf 'INFO: Which is less than the desired %sd minimum update interval.\n' "$(( update_interval / 86400 ))"
		return
	fi

	local latest_commit_date
	latest_commit_date="$(
		curl -s https://api.github.com/repos/wezterm/wezterm/commits | jq -r '.[0] | .commit.author.date' | sed -e 's/-//g' | cut -c1-8
	)"

	if [[ -z "${latest_commit_date}" ]]; then
		termux_error_exit "Unable to get latest commit date from ${TERMUX_PKG_SRCURL}"
	fi
	termux_pkg_upgrade_version "${latest_commit_date}"
}

termux_step_pre_configure() {
	termux_setup_rust

	sed -i 's/"vendored-fonts", //' wezterm-gui/Cargo.toml

	HOST_TRIPLET="$(gcc -dumpmachine)"
	PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="$(grep 'DefaultSearchPaths:' "/usr/share/pkgconfig/personality.d/${HOST_TRIPLET}.personality" | cut -d ' ' -f 2)"
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu
	export LIBSSH2_SYS_USE_PKG_CONFIG=1

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/mac_address \
		! -wholename ./vendor/libssh-rs-sys \
		! -wholename ./vendor/wgpu \
		! -wholename ./vendor/wayland-cursor \
		! -wholename ./vendor/starship-battery \
		! -wholename ./vendor/smithay-client-toolkit \
		! -wholename ./vendor/wgpu-hal \
		! -wholename ./vendor/cc \
		-exec rm -rf '{}' \;

	# rust-battery will not support Android
	# https://github.com/svartalf/rust-battery/issues/33#issuecomment-529193904
	# but if the "linux" backend for it is forced,
	# the wezterm battery information API
	# https://wezterm.org/config/lua/wezterm/battery_info.html
	# actually works and shows the correct battery level on my
	# Samsung Galaxy S8+ SM-G955F with LineageOS 21 Android 14.
	# Treat Android as Linux for this library.
	# on my Samsung Galaxy S9 SM-G960U with Samsung One UI 2.5 Android 10,
	# wezterm logs "permission denied", but with a handled error and does not crash
	# and other wezterm functionality is not impeded.
	find \
		vendor/mac_address \
		vendor/starship-battery \
		vendor/wgpu-hal \
		window \
		-type f -print0 | \
		xargs -0 sed -i \
		-e 's|\\"android\\"|\\"disabling_this_because_it_is_for_building_an_apk\\"|g' \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e 's|\\"linux\\"|\\"android\\"|g' \
		-e 's|"linux"|"android"|g'

	local patch="$TERMUX_PKG_BUILDER_DIR/libssh-rs-sys-termux.diff"
	local dir="vendor/libssh-rs-sys"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "${patch}"

	local patch="$TERMUX_PKG_BUILDER_DIR/wayland-cursor-no-shm.diff"
	local dir="vendor/wayland-cursor"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "${patch}"

	local patch="$TERMUX_PKG_BUILDER_DIR/smithay-client-toolkit-no-shm.diff"
	local dir="vendor/smithay-client-toolkit"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "${patch}"

	local patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	local dir="vendor/cc"
	echo "Applying patch: $patch"
	test -f "$patch"
	patch -p1 -d "$dir" < "$patch"

	sed -i '/\[patch.crates-io\]/a mac_address = { path = "./vendor/mac_address" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a libssh-rs-sys = { path = "./vendor/libssh-rs-sys" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a wayland-cursor = { path = "./vendor/wayland-cursor" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a starship-battery = { path = "./vendor/starship-battery" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a smithay-client-toolkit = { path = "./vendor/smithay-client-toolkit" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a wgpu-hal = { path = "./vendor/wgpu-hal" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a cc = { path = "./vendor/cc" }' Cargo.toml
}

termux_step_make() {
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--features distro-defaults
}

termux_step_make_install() {
	install -Dm755 "target/${CARGO_TARGET_NAME}/release/${TERMUX_PKG_NAME//-nightly/}" -t "${TERMUX_PREFIX}/bin"
	install -Dm755 "target/${CARGO_TARGET_NAME}/release/${TERMUX_PKG_NAME//-nightly/}-gui" -t "${TERMUX_PREFIX}/bin"
	install -Dm755 "target/${CARGO_TARGET_NAME}/release/${TERMUX_PKG_NAME//-nightly/}-mux-server" -t "${TERMUX_PREFIX}/bin"
	install -Dm755 "target/${CARGO_TARGET_NAME}/release/strip-ansi-escapes" -t "${TERMUX_PREFIX}/bin"
	install -Dm644 assets/icon/terminal.png "${TERMUX_PREFIX}/share/icons/hicolor/128x128/apps/org.wezfurlong.${TERMUX_PKG_NAME//-nightly/}.png"
	install -Dm644 "assets/${TERMUX_PKG_NAME//-nightly/}.desktop" "${TERMUX_PREFIX}/share/applications/org.wezfurlong.${TERMUX_PKG_NAME//-nightly/}.desktop"
	install -Dm644 "assets/${TERMUX_PKG_NAME//-nightly/}.appdata.xml" "${TERMUX_PREFIX}/share/metainfo/org.wezfurlong.${TERMUX_PKG_NAME//-nightly/}.appdata.xml"
	install -Dm644 "assets/${TERMUX_PKG_NAME//-nightly/}-nautilus.py" "${TERMUX_PREFIX}/share/nautilus-python/extensions/${TERMUX_PKG_NAME//-nightly/}-nautilus.py"
	install -Dm755 "assets/open-${TERMUX_PKG_NAME//-nightly/}-here" -t "${TERMUX_PREFIX}/bin"
	install -Dm644 README.md -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME//-nightly/}"
	install -Dm644 assets/shell-completion/bash "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME//-nightly/}"
	install -Dm644 assets/shell-completion/fish "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME//-nightly/}.fish"
	install -Dm644 assets/shell-completion/zsh "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME//-nightly/}"
	install -Dm644 assets/shell-integration/${TERMUX_PKG_NAME//-nightly/}.sh -t "${TERMUX_PREFIX}/etc/profile.d"
}
