TERMUX_PKG_HOMEPAGE=https://github.com/hrkfdn/ncspot
TERMUX_PKG_DESCRIPTION="An ncurses Spotify client written in Rust"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/hrkfdn/ncspot/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6bd08609a56aa5854a1964c9a872fe58b69a768d7d94c874d40d7a8848241213
TERMUX_PKG_DEPENDS="dbus, pulseaudio"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="ncspot-mpris"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--no-default-features
--features termion_backend,pulseaudio_backend
"
# NOTE: ncurses-rs runs a test while building which fails while cross compiling:
# therefore, we use termion_backend instead.
# share_clipboard cannot be used due to 1Password/arboard#56.

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust

	# bindgen-cli@0.71.0 is broken
	cargo install --force --locked bindgen-cli@0.69.5

	export TARGET_CMAKE_GENERATOR="Ninja"

	# Setup subsequent cmake running inside cargo
	# Crate used to invoke cmake does not work fine with cross-compilation so we wrap cmake
	_CMAKE="$TERMUX_PKG_TMPDIR/bin/cmake"
	mkdir -p "$(dirname "$_CMAKE")"

	echo "#!$(readlink /proc/$$/exe)" > "$_CMAKE"
	echo "echo CMAKE \"\$@\"" >> "$_CMAKE"
	echo "[[ \"\$@\" =~ \"--build\" ]] && exec $(command -v cmake) \"\$@\" || \
	exec $(command -v cmake) \
	-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=\"$TERMUX_STANDALONE_TOOLCHAIN\" \
	-DCMAKE_SYSTEM_NAME=Android \
	-DCMAKE_SYSTEM_VERSION=$TERMUX_PKG_API_LEVEL \
	-DCMAKE_LINKER=\"$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD\" \
	-DCMAKE_MAKE_PROGRAM=\"$(command -v ninja)\" \"\$@\"" >> "$_CMAKE"
	chmod +x "$_CMAKE"

	export PATH="$(dirname "$_CMAKE"):$PATH"
	CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	LDFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
}
