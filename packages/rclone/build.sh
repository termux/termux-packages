TERMUX_PKG_HOMEPAGE=https://rclone.org/
TERMUX_PKG_DESCRIPTION="rsync for cloud storage"
TERMUX_PKG_VERSION=1.41
TERMUX_PKG_SHA256=ad104981203d6ea6601f5d82c379c080e5183cb331b8b3d50491491e40617c3c
TERMUX_PKG_SRCURL=https://github.com/ncw/rclone/releases/download/v${TERMUX_PKG_VERSION}/rclone-v${TERMUX_PKG_VERSION}.tar.gz

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
