TERMUX_PKG_HOMEPAGE=https://syncthing.net/
TERMUX_PKG_DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
TERMUX_PKG_VERSION=0.14.27-rc.2
TERMUX_PKG_SRCURL=https://github.com/syncthing/syncthing/archive/v0.14.27-rc.2.tar.gz
TERMUX_PKG_SHA256=2243d3ddec966fef7f6563e3028c17f55916479a4e8fe5b30cd0960825f9f3b0
TERMUX_PKG_FOLDERNAME=syncthing-${TERMUX_PKG_VERSION}
termux_step_make(){
termux_setup_golang
mkdir -p go/src/github.com/syncthing/syncthing
export GOPATH=$(pwd)/go
cp $TERMUX_PKG_SRCDIR/vendor/* ./go/src/ -r
cp $TERMUX_PKG_SRCDIR/* -r go/src/github.com/syncthing/syncthing
cd go/src/github.com/syncthing/syncthing
export GO_ARCH=$GOARCH
unset GOOS
unset GOARCH  
go build build.go
./build -goos android -goarch $GO_ARCH -no-upgrade build
}
termux_step_make_install() {
cp go/src/github.com/syncthing/syncthing/syncthing $TERMUX_PREFIX/bin/
}
