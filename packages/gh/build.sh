TERMUX_PKG_HOMEPAGE=https://cli.github.com/
TERMUX_PKG_DESCRIPTION="GitHub’s official command line tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="2.63.2"
TERMUX_PKG_SRCURL=https://github.com/cli/cli/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2578a8b1f00cb292a8094793515743f2a86e02b8d0b18d6b95959ddbeebd6b8d
TERMUX_PKG_RECOMMENDS="openssh"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"
	(
		unset GOOS GOARCH CGO_LDFLAGS
		unset CC CXX CFLAGS CXXFLAGS LDFLAGS
		go run ./cmd/gen-docs --man-page --doc-path $TERMUX_PREFIX/share/man/man1/
	)
	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/cli/
	mkdir -p "$TERMUX_PREFIX"/share/doc/gh
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/cli/cli
	cd "$GOPATH"/src/github.com/cli/cli/cmd/gh
	go get -d -v
	go build -ldflags="-X github.com/cli/cli/v${TERMUX_PKG_VERSION%%.*}/internal/build.Version=$TERMUX_PKG_VERSION"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/cli/cli/cmd/gh/gh
	install -Dm600 -t "$TERMUX_PREFIX"/share/doc/gh/ "$TERMUX_PKG_SRCDIR"/docs/*

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/gh.bash
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_gh
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/gh.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		gh completion -s bash > ${TERMUX_PREFIX}/share/bash-completion/completions/gh.bash
		gh completion -s zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_gh
		gh completion -s fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/gh.fish
	EOF
}
