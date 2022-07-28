TERMUX_PKG_HOMEPAGE="https://github.com/charmbracelet/gum"
TERMUX_PKG_DESCRIPTION="A tool for creating minimal interactive TUIs for shell scripts"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.0"
TERMUX_PKG_SRCURL="https://github.com/charmbracelet/gum/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=504a92791dacaa06e025a7fea32f96f9d4f67b26a38b1a07eb2703e5519cea1b
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	cd "$TERMUX_PKG_SRCDIR"
	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	go build
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "${TERMUX_PKG_SRCDIR}/gum"
}

termux_step_create_debscripts() {
	# Note: the following lines should be indented with *tabs* (not spaces)
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh

	# Generating manpages
	printf >&2 "%s\n" "Generating manpages for gum"
	mkdir -p "$TERMUX_PREFIX/share/man/man1"
	if ! gum man > "$TERMUX_PREFIX/share/man/man1/gum.1"; then
		printf >&2 "\t%s\n" "manpages for gum: FAILED"
	fi

	# Generating shell completions
	printf >&2 "%s\n" "Generating shell completions for gum"
	mkdir -p "$TERMUX_PREFIX/share/bash-completion/completions"
	mkdir -p "$TERMUX_PREFIX/share/zsh/site-functions"
	mkdir -p "$TERMUX_PREFIX/share/fish/vendor_completions.d"
	if ! gum completion bash \
		> "$TERMUX_PREFIX/share/bash-completion/completions/gum"; then
		printf >&2 "\t%s\n" "bash completions for gum: FAILED"
	fi
	if ! gum completion zsh \
		> "$TERMUX_PREFIX/share/zsh/site-functions/_gum"; then
		printf >&2 "\t%s\n" "zsh completions for gum: FAILED"
	fi
	if ! gum completion fish \
		> "$TERMUX_PREFIX/share/fish/vendor_completions.d/gum.fish"; then
		printf >&2 "\t%s\n" "fish completions for gum: FAILED"
	fi
	EOF

	cat <<- EOF > ./postrm
	#!$TERMUX_PREFIX/bin/sh
	rm -f "$TERMUX_PREFIX/share/man/man1/gum.1"
	rm -f "$TERMUX_PREFIX/share/bash-completion/completions/gum"
	rm -f "$TERMUX_PREFIX/share/zsh/site-functions/_gum"
	rm -f "$TERMUX_PREFIX/share/fish/vendor_completions.d/gum.fish"
	EOF
}
