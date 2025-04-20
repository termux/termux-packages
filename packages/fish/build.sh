TERMUX_PKG_HOMEPAGE=https://fishshell.com/
TERMUX_PKG_DESCRIPTION="The user-friendly command line shell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/fish-shell/fish-shell/releases/download/$TERMUX_PKG_VERSION/fish-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6e1ecdb164285fc057b2f35acbdc20815c1623099e7bb47bbfc011120adf7e83
TERMUX_PKG_AUTO_UPDATE=true
# fish calls 'tput' from ncurses-utils, at least when cancelling (Ctrl+C) a command line.
# man is needed since fish calls apropos during command completion.
TERMUX_PKG_DEPENDS="bc, libandroid-support, libandroid-spawn, libc++, ncurses, ncurses-utils, mandoc, pcre2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_DOCS=OFF
-DFISH_USE_SYSTEM_PCRE2=ON
-DMAC_CODESIGN_ID=OFF
-DWITH_GETTEXT=OFF
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust

	# FindRust.cmake auto pick thumbv7neon-linux-androideabi
	[[ "${TERMUX_ARCH}" == "arm" ]] && TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_ANDROID_ARM_MODE=ON"

	# older than Android 8 dont have ctermid
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c ${TERMUX_PKG_BUILDER_DIR}/ctermid.c
	"${AR}" cru libctermid.a ctermid.o

	# cmake invokes rustc directly leaving CARGO_TARGET_*_RUSTFLAGS unused
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export RUSTFLAGS=$(env | grep CARGO_TARGET_${env_host}_RUSTFLAGS | cut -d'=' -f2-)
	RUSTFLAGS+=" -C link-arg=-landroid-spawn"
	RUSTFLAGS+=" -L${TERMUX_PKG_BUILDDIR} -C link-arg=-l:libctermid.a"

	: "${CARGO_HOME:=${HOME}/.cargo}"
	export CARGO_HOME

	rm -rf "$CARGO_HOME"/registry/src/*/libc-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	local libc p
	for libc in "${CARGO_HOME}"/registry/src/*/libc-*; do
		for p in "${TERMUX_PKG_BUILDER_DIR}"/libc-*.diff; do
			[[ -f "${p}" ]] && patch -p1 -d "${libc}" -i "${p}" || termux_error_exit "fish: failed to apply patch '$p'"
		done
	done
}

termux_step_post_make_install() {
	cat >> "$TERMUX_PREFIX/etc/fish/config.fish" <<-EOF
	function __fish_command_not_found_handler --on-event fish_command_not_found
		$TERMUX_PREFIX/libexec/termux/command-not-found \$argv[1]
	end

	# TODO: remove when https://github.com/termux/termux-app/pull/4417 gets released
	status test-feature keyboard-protocols && set -U fish_features no-keyboard-protocols
	EOF
}

termux_step_post_massage() {
	rm -rf "$CARGO_HOME"/registry/src/*/libc-*
}
