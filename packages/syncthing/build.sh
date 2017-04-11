TERMUX_PKG_HOMEPAGE=https://syncthing.net/
TERMUX_PKG_DESCRIPTION="Decentralized file synchronization"
TERMUX_PKG_VERSION=0.14.27-rc.2
TERMUX_PKG_SRCURL=https://github.com/syncthing/syncthing/archive/v0.14.27-rc.2.tar.gz
TERMUX_PKG_SHA256=2243d3ddec966fef7f6563e3028c17f55916479a4e8fe5b30cd0960825f9f3b0
TERMUX_PKG_FOLDERNAME=syncthing-${TERMUX_PKG_VERSION}

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

	# Unset GOARCH so building build.go is works.
	export GO_ARCH=$GOARCH
	unset GOOS GOARCH

	# Now file structure is same as go get etc.
	go build build.go
	./build -goos android \
		-goarch $GO_ARCH \
		-no-upgrade \
		-version v$TERMUX_PKG_VERSION \
		build

}

termux_step_make_install() {
	cp go/src/github.com/syncthing/syncthing/syncthing $TERMUX_PREFIX/bin/
}
