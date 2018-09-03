TERMUX_PKG_HOMEPAGE=https://rclone.org/
TERMUX_PKG_DESCRIPTION="rsync for cloud storage"
TERMUX_PKG_VERSION=1.43
TERMUX_PKG_SHA256=d30527b00cecb4e5e7188dddb78e5cec62d67cf2422dab82190db58512b5a4e3
TERMUX_PKG_SRCURL=https://github.com/ncw/rclone/releases/download/v${TERMUX_PKG_VERSION}/rclone-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	mkdir -p .gopath/src/github.com/ncw
	ln -sf "$PWD" .gopath/src/github.com/ncw/rclone
	export GOPATH="$PWD/.gopath"

	go build -v -o rclone

	# XXX: Fix read-only files which prevents removal of src dir.
	chmod u+w -R .

	cp rclone $TERMUX_PREFIX/bin/rclone
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp rclone.1 $TERMUX_PREFIX/share/man/man1/
}
