TERMUX_PKG_HOMEPAGE=https://github.com/hrkfdn/ncspot
TERMUX_PKG_DESCRIPTION="An ncurses Spotify client written in Rust"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://github.com/hrkfdn/ncspot/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0df821a5ea70a143d3529abadd39bcdd9643720a602c99a9c0f8f31f52b4a0fb
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
	# termux_setup_rust resets CFLAGS so doing that in subshell
	( termux_setup_rust )
	export PATH="${HOME}/.cargo/bin:${PATH}"

	termux_setup_ninja
	termux_setup_cmake
	[ -f ~/.cargo/bin/bindgen ] || cargo install --force --locked bindgen-cli

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
