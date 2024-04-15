TERMUX_PKG_HOMEPAGE=https://just.systems
TERMUX_PKG_DESCRIPTION="A handy way to save and run project-specific commands"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@flipee"
TERMUX_PKG_VERSION="1.25.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/casey/just/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5a005a4de9f99b297ba7b5dc02c3365c689e579148790660384afee0810a2342
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm644 -t "$TERMUX_PREFIX/share/man/man1/" "man/just.1"

	# these are generated, but not available from the binary itself, need to figure out where to put them anyway
	# install -Dm644 "completions/just.nu" "$TERMUX_PREFIX/share/zsh/site-functions/_just"
	install -Dm644 "completions/just.zsh" "$TERMUX_PREFIX/share/zsh/site-functions/_just"
	install -Dm644 "completions/just.bash" "$TERMUX_PREFIX/share/bash-completion/completions/just"
	install -Dm644 "completions/just.fish" "$TERMUX_PREFIX/share/fish/vendor_completions.d/just.fish"
	install -Dm644 "completions/just.elvish" "$TERMUX_PREFIX/share/elvish/lib/just.elv"
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		just --completions    zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_just"
		just --completions   bash > "${TERMUX_PREFIX}/share/bash-completion/completions/just"
		just --completions   fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/just.fish"
		just --completions elvish > "${TERMUX_PREFIX}/share/elvish/lib/just.elv"
	EOF
}
