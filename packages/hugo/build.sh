TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="A fast and flexible static site generator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.115.3"
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1c6b089306c22325f3b2a43c69ba878d63c3ca472f07365c99adc1b0e45624d9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR
	go build \
		-o "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/hugo" \
		-tags "linux extended" \
		main.go
		# "linux" tag should not be necessary
		# try removing when golang version is upgraded

	# Building for host to generate manpages and completion.
	chmod 700 -R $GOPATH/pkg && rm -rf $GOPATH/pkg
	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go build \
		-o "$TERMUX_PKG_BUILDDIR/hugo" \
		-tags "linux extended" \
		main.go
		# "linux" tag should not be necessary
		# try removing when golang version is upgraded
}

termux_step_make_install() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/{bash-completion/completions,zsh/site-functions,fish/vendor_completions.d,man/man1}

	$TERMUX_PKG_BUILDDIR/hugo completion bash > $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/bash-completion/completions/hugo
	$TERMUX_PKG_BUILDDIR/hugo completion zsh > $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/zsh/site-functions/_hugo
	$TERMUX_PKG_BUILDDIR/hugo completion fish > $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/fish/vendor_completions.d/hugo.fish

	$TERMUX_PKG_BUILDDIR/hugo gen man \
		--dir=$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man1/
}
