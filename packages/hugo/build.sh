TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="A fast and flexible static site generator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.92.2
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=00d61205f426587dcfc4e2844a6f9fb451c825b828c00f0b46e3d0930c132751
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR
	go build \
		-o "$TERMUX_PREFIX/bin/hugo" \
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
	mkdir -p $TERMUX_PREFIX/share/{bash-completion/completions,zsh/site-functions,fish/vendor_completions.d,man/man1}

	$TERMUX_PKG_BUILDDIR/hugo completion bash > $TERMUX_PREFIX/share/bash-completion/completions/hugo
	$TERMUX_PKG_BUILDDIR/hugo completion zsh > $TERMUX_PREFIX/share/zsh/site-functions/_hugo
	$TERMUX_PKG_BUILDDIR/hugo completion fish > $TERMUX_PREFIX/share/fish/vendor_completions.d/hugo.fish

	$TERMUX_PKG_BUILDDIR/hugo gen man \
		--dir=$TERMUX_PREFIX/share/man/man1/
}
