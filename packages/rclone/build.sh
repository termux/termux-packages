TERMUX_PKG_HOMEPAGE=https://rclone.org/
TERMUX_PKG_DESCRIPTION="rsync for cloud storage"
TERMUX_PKG_VERSION=1.40
TERMUX_PKG_SRCURL=https://github.com/ncw/rclone/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9faead37d01681ea10cf1d3c9a0d2db241fa858212f3d0aa0325096168a97abd

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	mkdir -p .gopath/src/github.com/ncw
	ln -sf "$PWD" .gopath/src/github.com/ncw/rclone
	export GOPATH="$PWD/.gopath"

	go build -v -o rclone

	cp rclone $TERMUX_PREFIX/bin/rclone
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp rclone.1 $TERMUX_PREFIX/share/man/man1/
}
