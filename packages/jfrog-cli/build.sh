TERMUX_PKG_HOMEPAGE=https://jfrog.com/getcli
TERMUX_PKG_DESCRIPTION="A CLI for JFrog products."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8.2
TERMUX_PKG_SRCURL=https://github.com/jfrog/jfrog-cli/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=eef227f5d222804894195759c70ef09de1d350467439223c665872aed039cd1b
TERMUX_PKG_AUTO_UPDATE=true
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
	export JFROG_CLI_HOME_DIR=$TERMUX_PKG_BUILDDIR/.jfrog
	$TERMUX_PKG_BUILDDIR/jfrog completion bash
	cp $TERMUX_PKG_BUILDDIR/.jfrog/jfrog_bash_completion $TERMUX_PREFIX/share/bash-completion/completions/jfrog

}
