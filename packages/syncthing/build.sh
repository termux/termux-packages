TERMUX_PKG_HOMEPAGE=https://syncthing.net/
TERMUX_PKG_DESCRIPTION="Decentralized file synchronization"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# NOTE: as of 1.12.0 compilation fails when package zstd is
# present in TERMUX_PREFIX.
TERMUX_PKG_VERSION=1.18.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/syncthing/syncthing/releases/download/v${TERMUX_PKG_VERSION}/syncthing-source-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32c11a56f467b5f9a45ff30da38953387da10d71b4d3cb41643c6a6f5c073c7a
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make(){
	termux_setup_golang

	# The build.sh script doesn't with our compiler
	# so small adjustments to file locations are needed
	# so the build.go is fine.
	mkdir -p go/src/github.com/syncthing/syncthing
	cp $TERMUX_PKG_SRCDIR/vendor/* ./go/src/ -r
	cp $TERMUX_PKG_SRCDIR/*  go/src/github.com/syncthing/syncthing -r

	# Set gopath so dependencies are built as in go get etc.
	export GOPATH=$(pwd)/go

	cd go/src/github.com/syncthing/syncthing

	# Unset GOARCH so building build.go works.
	export GO_ARCH=$GOARCH
	export _CC=$CC
	unset GOOS GOARCH CC

	# Now file structure is same as go get etc.
	go build build.go
	export CC=$_CC
	./build -goos android \
		-goarch $GO_ARCH \
		-no-upgrade \
		-version v$TERMUX_PKG_VERSION \
		build
}

termux_step_make_install() {
	cp go/src/github.com/syncthing/syncthing/syncthing $TERMUX_PREFIX/bin/

	for section in 1 5 7; do
		local MANDIR=$TERMUX_PREFIX/share/man/man$section
		mkdir -p $MANDIR
		cp $TERMUX_PKG_SRCDIR/man/*.$section $MANDIR
	done
}
