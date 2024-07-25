TERMUX_PKG_HOMEPAGE="https://github.com/charmbracelet/gum"
TERMUX_PKG_DESCRIPTION="A tool for creating minimal interactive TUIs for shell scripts"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.3"
TERMUX_PKG_SRCURL="https://github.com/charmbracelet/gum/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=954e37c4c35e877bffd5bec7c794bee254db95f8a4e005136d94c7db456db398
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	cd "$TERMUX_PKG_SRCDIR"
	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	go build
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "${TERMUX_PKG_SRCDIR}/gum"

	install -Dm644 /dev/null $TERMUX_PREFIX/share/man/man1/gum.1
	install -Dm644 /dev/null $TERMUX_PREFIX/share/bash-completion/completions/gum
	install -Dm644 /dev/null $TERMUX_PREFIX/share/zsh/site-functions/_gum
	install -Dm644 /dev/null $TERMUX_PREFIX/share/fish/vendor_completions.d/gum.fish
}

termux_step_create_debscripts() {
	# Note: the following lines should be indented with *tabs* (not spaces)
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh

	# Generating manpages
	printf >&2 "%s\n" "Generating manpages for gum"
	if ! gum man > "$TERMUX_PREFIX/share/man/man1/gum.1"; then
		printf >&2 "\t%s\n" "manpages for gum: FAILED"
	fi

	# Generating shell completions
	printf >&2 "%s\n" "Generating shell completions for gum"
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
}
