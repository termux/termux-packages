TERMUX_PKG_HOMEPAGE=https://fishshell.com/
TERMUX_PKG_DESCRIPTION="The user-friendly command line shell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.7.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/fish-shell/fish-shell/releases/download/$TERMUX_PKG_VERSION/fish-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=6f4d5b438a6338e3f5dcda19a28261e2ece7a9b7ff97686685e6abdc31dbb7df
# fish calls 'tput' from ncurses-utils, at least when cancelling (Ctrl+C) a command line.
# man is needed since fish calls apropos during command completion.
TERMUX_PKG_DEPENDS="bc, libandroid-support, libc++, mandoc, ncurses, ncurses-utils, pcre2"
TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="sphinx"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFISH_USE_SYSTEM_PCRE2=ON
-DMAC_CODESIGN_ID=OFF
-DWITH_MESSAGE_LOCALIZATION=OFF
"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust

	mkdir "$TERMUX_PKG_SRCDIR/build"
	pushd "$TERMUX_PKG_SRCDIR/build"
	cmake .. -GNinja -DWITH_DOCS=ON -DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX"
	ninja -j "$TERMUX_PKG_MAKE_PROCESSES" install
	popd
}

termux_step_pre_configure() {
	rm -rf "$TERMUX_HOSTBUILD_MARKER"

	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust

	# FindRust.cmake auto pick thumbv7neon-linux-androideabi
	[[ "${TERMUX_ARCH}" == "arm" ]] && TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_ANDROID_ARM_MODE=ON"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRust_CARGO_TARGET=$CARGO_TARGET_NAME"

	# older than Android 8 dont have ctermid
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c ${TERMUX_PKG_BUILDER_DIR}/ctermid.c
	"${AR}" cru libctermid.a ctermid.o

	# cmake invokes rustc directly leaving CARGO_TARGET_*_RUSTFLAGS unused
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export RUSTFLAGS=$(env | grep CARGO_TARGET_${env_host}_RUSTFLAGS | cut -d'=' -f2-)
	# enable if libandroid-spawn is tested with fish in the future
	# and confirmed to start working again
	#RUSTFLAGS+=" -C link-arg=-landroid-spawn"
	RUSTFLAGS+=" -L${TERMUX_PKG_BUILDDIR} -C link-arg=-l:libctermid.a"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWITH_DOCS=ON"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWITH_DOCS=OFF"
	fi
}

termux_step_post_make_install() {
	cat >> "$TERMUX_PREFIX/etc/fish/config.fish" <<-EOF
	function __fish_command_not_found_handler --on-event fish_command_not_found
		$TERMUX_PREFIX/libexec/termux/command-not-found \$argv[1]
	end
	EOF
}
