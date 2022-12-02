TERMUX_PKG_HOMEPAGE=https://nuetzlich.net/gocryptfs/
TERMUX_PKG_DESCRIPTION="An encrypted overlay filesystem written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/rfjakob/gocryptfs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a59c0f2889b3330aac3242a67d1930bc564bfdf28068288a0cd1bfb9b69fa0e
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	local GITVERSIONFUSE=$(go list -m github.com/hanwen/go-fuse/v2 | cut -d' ' -f2-)
	local GO_LDFLAGS="-extldflags=-Wl,-rpath=$TERMUX_PREFIX/lib"
	GO_LDFLAGS+=" -X \"main.GitVersion=v${TERMUX_PKG_VERSION#*:}\""
	GO_LDFLAGS+=" -X \"main.GitVersionFuse=$GITVERSIONFUSE\""
	GO_LDFLAGS+=" -X \"main.BuildDate=$(date +%Y-%m-%d)\""
	go build -ldflags "$GO_LDFLAGS"
	go build -ldflags "$GO_LDFLAGS" \
		-o ./gocryptfs-xray/gocryptfs-xray ./gocryptfs-xray
	./Documentation/MANPAGE-render.bash
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./gocryptfs
	install -Dm700 -t $TERMUX_PREFIX/bin ./gocryptfs-xray/gocryptfs-xray
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		./Documentation/gocryptfs{,-xray}.1
}
