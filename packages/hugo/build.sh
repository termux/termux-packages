TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="A fast and flexible static site generator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.88.1
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=da5f52437bfc7521b194b39d36a8cf7b2775e70e1ba8c443f81a14f468608507
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
	mkdir -p $TERMUX_PREFIX/share/{bash-completion/completions,man/man1}

	$TERMUX_PKG_BUILDDIR/hugo gen autocomplete \
		--completionfile=$TERMUX_PREFIX/share/bash-completion/completions/hugo
	$TERMUX_PKG_BUILDDIR/hugo gen man \
		--dir=$TERMUX_PREFIX/share/man/man1/
}
