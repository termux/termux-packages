TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=asciinema-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	export GOOS=android
	export GO_LDFLAGS="-extldflags=-pie"
	export CGO_ENABLED=1
	if [ "$TERMUX_ARCH" = "arm" ]; then
		export GOARCH=arm
		export GOARM=7
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		export GOARCH=386
		export GO386=sse2
	else
		echo "ERROR: Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi

	export GOPATH=$TERMUX_PKG_TMPDIR
	cd $GOPATH
	mkdir -p src/github.com/asciinema/asciinema/
	cp -Rf $TERMUX_PKG_SRCDIR/* src/github.com/asciinema/asciinema/
}

termux_step_make_install () {
	cd $GOPATH/src/github.com/asciinema/asciinema
	export GOROOT=$HOME/lib/go/
	export PATH=$PATH:$GOROOT/bin/
	PREFIX=$TERMUX_PREFIX make build
	PREFIX=$TERMUX_PREFIX make install
}
