TERMUX_PKG_HOMEPAGE=https://sorairolake.github.io/qrtool/
TERMUX_PKG_DESCRIPTION="A command-line utility for encoding and decoding QR codes"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSES/Apache-2.0.txt, LICENSES/MIT.txt, LICENSES/CC-BY-4.0.txt"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION="0.13.2"
TERMUX_PKG_SRCURL="https://github.com/sorairolake/qrtool/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ec6d240667a06a191188a44037b7173811d736c086c607d82d6d9b374c9332d8
TERMUX_PKG_BUILD_DEPENDS="asciidoctor"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		-exec rm -rf {} +

	local cc_patch="${TERMUX_PKG_BUILDER_DIR}/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	patch -p1 -d vendor/cc < "${cc_patch}"

	cat >> Cargo.toml <<-'EOF'

		[patch.crates-io]
		cc.path = "./vendor/cc"
EOF
}

termux_step_post_make_install() {
	asciidoctor -b manpage docs/man/man1/*.1.adoc
	install -Dm600 -t "${TERMUX__PREFIX__SHARE_DIR}/man/man1" docs/man/man1/*.1

	local -A completions=(
		[bash]="bash-completion/completions/${TERMUX_PKG_NAME}"
		[elvish]="elvish/lib/${TERMUX_PKG_NAME}.elv"
		[fish]="fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
		[nushell]="nushell/vendor/autoload/${TERMUX_PKG_NAME}.nu"
		[zsh]="zsh/site-functions/_${TERMUX_PKG_NAME}"
	)

	local path shell
	for shell in "${!completions[@]}"; do
		path="${TERMUX__PREFIX__SHARE_DIR}/${completions[${shell}]}"
		mkdir -p "${path%/*}"
		cargo run -- completion "${shell}" > "${path}"
	done
}
