TERMUX_PKG_HOMEPAGE=https://git-lfs.github.com/
TERMUX_PKG_DESCRIPTION="Git extension for versioning large files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.13.1
TERMUX_PKG_SRCURL=https://github.com/git-lfs/git-lfs/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5ba7d945d96ad49492e29edbfd1cce528b2a034fdddbf6e5424e754a4a012029

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p "$GOPATH"/github.com/git-lfs
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/github.com/git-lfs/git-lfs

	cd "$GOPATH"/github.com/git-lfs/git-lfs
	! $TERMUX_ON_DEVICE_BUILD && GOOS=linux GOARCH=amd64 CC=gcc LD=gcc go generate github.com/git-lfs/git-lfs/commands
	go build git-lfs.go
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/github.com/git-lfs/git-lfs/git-lfs \
		"$TERMUX_PREFIX"/bin/git-lfs
}

termux_step_post_make_install() {
	# Remove read-only files generated in build process.
	chmod -R 700 "$TERMUX_PKG_BUILDDIR"/pkg
	rm -rf "$TERMUX_PKG_BUILDDIR"/pkg
}
