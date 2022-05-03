TERMUX_PKG_HOMEPAGE=https://syncthing.net/
TERMUX_PKG_DESCRIPTION="Decentralized file synchronization"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# NOTE: as of 1.12.0 compilation fails when package zstd is
# present in TERMUX_PREFIX.
TERMUX_PKG_VERSION="1.20.0"
TERMUX_PKG_SRCURL=https://github.com/syncthing/syncthing/releases/download/v${TERMUX_PKG_VERSION}/syncthing-source-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6dc78dbe046f2fa9a4f70b04cf2500705d3a22618f5cf430ffcb7338cce968c7
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	# The build.sh script doesn't with our compiler
	# so small adjustments to file locations are needed
	# so the build.go is fine.
	mkdir -p go/src/github.com/syncthing
	ln -sf "${TERMUX_PKG_SRCDIR}" go/src/github.com/syncthing/syncthing

	# Set gopath so dependencies are built as in go get etc.
	export GOPATH="$(pwd)/go"

	cd go/src/github.com/syncthing/syncthing

	# Unset GOARCH so building build.go works.
	export GO_ARCH="${GOARCH}"
	export _CC="${CC}"
	export GO_OS="${GOOS}"
	unset GOOS GOARCH CC

	rm -rf vendor # syncthing has vendored dependencies, which fails with our compiler.
	# Now file structure is same as go get etc.
	go run build.go -goos "${GO_OS}" -goarch "${GO_ARCH}" \
		-cc "${_CC}" -version "v${TERMUX_PKG_VERSION}" -no-upgrade build
}

termux_step_make_install() {
	cp "${GOPATH}"/src/github.com/syncthing/syncthing/syncthing $TERMUX_PREFIX/bin/

	for section in 1 5 7; do
		local MANDIR=$TERMUX_PREFIX/share/man/man$section
		mkdir -p $MANDIR
		cp $TERMUX_PKG_SRCDIR/man/*.$section $MANDIR
	done
}
