TERMUX_PKG_HOMEPAGE=https://jfrog.com/getcli
TERMUX_PKG_DESCRIPTION="A CLI for JFrog products."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.35.1
TERMUX_PKG_SRCURL=https://github.com/jfrog/jfrog-cli/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e7549c49a270090b66745b17b7f1b4dea941809e8bcac69e4bddb3ed7498b479
TERMUX_PKG_DEPENDS="libc++"

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR
	go build \
		-o "$TERMUX_PREFIX/bin/jfrog" \
		-tags "linux extended" \
		main.go
		# "linux" tag should not be necessary
		# try removing when golang version is upgraded

	# Building for host to generate manpages and completion.
	chmod 700 -R $GOPATH/pkg && rm -rf $GOPATH/pkg
	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go build \
		-o "$TERMUX_PKG_BUILDDIR/jfrog" \
		-tags "linux extended" \
		main.go
		# "linux" tag should not be necessary
		# try removing when golang version is upgraded
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions
	$TERMUX_PKG_BUILDDIR/jfrog completion bash
	cp ~/.jfrog/jfrog_bash_completion $TERMUX_PREFIX/share/bash-completion/completions/jfrog

}
