TERMUX_PKG_HOMEPAGE=https://restic.net/
TERMUX_PKG_DESCRIPTION="Fast, secure, efficient backup program"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=0.9.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/restic/restic/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c7dca90fb6fd83cee8b9f6a2776f5839794341af1953d251bf06a91870be7a8e
TERMUX_PKG_SUGGESTS="openssh, rclone"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	_GOARCH=${GOARCH}
	unset GOOS GOARCH

	## build for host and regenerate manpages
	go run build.go --goos linux --goarch "amd64"
	./restic generate --man doc/man && rm -f ./restic

	## finally build for target
	go run build.go --enable-cgo --goos android --goarch "${_GOARCH}"
}

termux_step_make_install() {
	install -Dm700 restic "$TERMUX_PREFIX"/bin/restic
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1/" doc/man/*.1
}
