TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://restic.net/
TERMUX_PKG_DESCRIPTION="Fast, secure, efficient backup program"
TERMUX_PKG_VERSION=0.9.2
TERMUX_PKG_SRCURL=https://github.com/restic/restic/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8f8eee3e9651b9f7384a323ba3c26a5667a6388ab2ef8e6d869d3cd69b9f7c95
#TERMUX_PKG_RECOMMENDS="dropbear | openssh, rclone"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	_GOARCH=${GOARCH}
	unset GOOS GOARCH

	## build for host and regenerate manpages
	go run build.go --goos linux \
			--goarch "amd64"
	./restic generate --man doc/man && rm -f ./restic

	## finally build for target
	go run build.go --enable-cgo \
			--goos android \
			--goarch "${_GOARCH}"
}

termux_step_make_install() {
	install -Dm755 restic "${TERMUX_PREFIX}/bin/restic"
	mkdir -p "${TERMUX_PREFIX}/share/man/man1/"
	install -Dm644 doc/man/*.1 "${TERMUX_PREFIX}/share/man/man1/"
}
