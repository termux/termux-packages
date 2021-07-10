TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="A fast and flexible static site generator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.85.0
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9f1c983fe649f0d602481c848ebf863c9d3b3bc9c0e6a237c35e96e33a1b5d24
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	termux_go_get
	go build \
		-o hugo \
		main.go
	if ! $TERMUX_ON_DEVICE_BUILD; then
		chmod 700 -R $GOPATH/pkg && rm -rf $GOPATH/pkg
		unset GOOS GOARCH CGO_LDFLAGS
		unset CC CXX CFLAGS CXXFLAGS LDFLAGS
		go build \
			-o hugo-host \
			main.go
	fi
}

termux_step_make_install() {
	if $TERMUX_ON_DEVICE_BUILD; then
		export HUGO=$TERMUX_PKG_SRCDIR/hugo
	else
		export HUGO=$TERMUX_PKG_SRCDIR/hugo-host
	fi
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$TERMUX_PKG_SRCDIR"/hugo
	mkdir -p $TERMUX_PREFIX/share/{bash-completion/completions,man/man1}

	$HUGO gen autocomplete \
		--completionfile=$TERMUX_PREFIX/share/bash-completion/completions/hugo
	$HUGO gen man \
		--dir=$TERMUX_PREFIX/share/man/man1/
}
