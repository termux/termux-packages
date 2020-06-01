TERMUX_PKG_HOMEPAGE=https://rclone.org/
TERMUX_PKG_DESCRIPTION="rsync for cloud storage"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.52.0
TERMUX_PKG_SRCURL=https://github.com/rclone/rclone/releases/download/v${TERMUX_PKG_VERSION}/rclone-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b8cd06f62fa1623aa77e8a8f60f4a30c02c84c97488ded159968bf07beedf31b

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	mkdir -p .gopath/src/github.com/rclone
	ln -sf "$PWD" .gopath/src/github.com/rclone/rclone
	export GOPATH="$PWD/.gopath"

	# google.golang.org/grpc/internal/syscall does not build with GO111MODULE=on
	# Remove when possible
	export GO111MODULE=off
	go build -v -o rclone

	# XXX: Fix read-only files which prevents removal of src dir.
	chmod u+w -R .

	cp rclone $TERMUX_PREFIX/bin/rclone
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp rclone.1 $TERMUX_PREFIX/share/man/man1/
}
