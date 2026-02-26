TERMUX_PKG_HOMEPAGE=https://getfresh.dev/
TERMUX_PKG_DESCRIPTION="Text editor for your terminal: easy, powerful and fast"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.9"
TERMUX_PKG_SRCURL="https://github.com/sinelaw/fresh/releases/download/v$TERMUX_PKG_VERSION/fresh-editor-$TERMUX_PKG_VERSION-source.tar.gz"
TERMUX_PKG_SHA256=cd4a96ca721796a61df49124e6bb95d478862d6a080789314fa6a19178cf3bc4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/trash \
		! -wholename ./vendor/arboard \
		! -wholename ./vendor/x11rb-protocol \
		! -wholename ./vendor/cc \
		! -wholename ./vendor/winit \
		! -wholename ./vendor/x11rb-protocol \
		! -wholename ./vendor/xkbcommon-dl \
		! -wholename ./vendor/wayland-cursor \
		! -wholename ./vendor/smithay-client-toolkit \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	local dir="vendor/cc"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	patch="$TERMUX_PKG_BUILDER_DIR/trash-rs-implement-get_mount_points-android.diff"
	dir="vendor/trash"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	patch="$TERMUX_PKG_BUILDER_DIR/wayland-cursor-no-shm.diff"
	dir="vendor/wayland-cursor"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	patch="$TERMUX_PKG_BUILDER_DIR/smithay-client-toolkit-no-shm.diff"
	dir="vendor/smithay-client-toolkit"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "${patch}"

	find vendor/{trash,arboard,x11rb-protocol,xkbcommon-dl,winit,wayland-cursor,smithay-client-toolkit} -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e 's|"linux"|"android"|g' \
		-e "s|libxkbcommon.so.0|libxkbcommon.so|g" \
		-e "s|libxkbcommon-x11.so.0|libxkbcommon-x11.so|g" \
		-e "s|libxcb.so.1|libxcb.so|g" \
		-e "s|/tmp|$TERMUX_PREFIX/tmp|g"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	for crate in trash arboard cc winit x11rb-protocol xkbcommon-dl wayland-cursor smithay-client-toolkit; do
		echo "$crate = { path = \"./vendor/$crate\" }" >> Cargo.toml
	done

	# error: function-like macro '__GLIBC_USE' is not defined
	export BINDGEN_EXTRA_CLANG_ARGS="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
	case "${TERMUX_ARCH}" in
	arm) BINDGEN_EXTRA_CLANG_ARGS+=" --target=arm-linux-androideabi" ;;
	*) BINDGEN_EXTRA_CLANG_ARGS+=" --target=${TERMUX_ARCH}-linux-android" ;;
	esac
}

termux_step_make() {
	if [[ "$TERMUX_ARCH_BITS" == "64" ]]; then
		cargo build \
			--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
			--target "$CARGO_TARGET_NAME" \
			--release
	else
		# for some reason, this is required only for 32-bit Android targets to prevent
		# "error[E0422]: cannot find struct, variant or union type `JSValueUnion` in this scope"
		# issue has been reported, but for the other person, they were actually trying to build
		# for a 64-bit target, but their problem was that they were stuck building for 32-bit
		# and that's why they had that error
		# https://github.com/DelSkayn/rquickjs/issues/600
		cargo build \
			--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
			--target "$CARGO_TARGET_NAME" \
			--release \
			--package "$TERMUX_PKG_NAME" \
			--no-default-features \
			--features runtime
	fi
}

termux_step_make_install() {
	# based on AUR package https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=fresh-editor
	rm -rf "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME"

	install -Dm755 "target/${CARGO_TARGET_NAME}/release/fresh" "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/fresh"
	install -dm755 "$TERMUX_PREFIX/bin"
	ln -sf "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/fresh" "$TERMUX_PREFIX/bin/fresh"

	install -Dm644 README.md "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/README.md"

	if [[ "$TERMUX_ARCH_BITS" == "64" ]]; then
		# Plugins
		cp -r crates/fresh-editor/plugins "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/"
	fi

	# Keymaps
	cp -r crates/fresh-editor/keymaps "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/"
}

termux_step_post_make_install() {
	"$TERMUX_ELF_CLEANER" --api-level "$TERMUX_PKG_API_LEVEL" "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/fresh"
}
