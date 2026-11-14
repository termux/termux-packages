TERMUX_PKG_HOMEPAGE=https://nuetzlich.net/gocryptfs/
TERMUX_PKG_DESCRIPTION="An encrypted overlay filesystem written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.0"
TERMUX_PKG_SRCURL=https://github.com/rfjakob/gocryptfs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=71cf484a4c1a26c2d1286bdd39ba19bbbd558b4c6c08574bb3177c8817a1f517
TERMUX_PKG_DEPENDS="openssl, libfuse2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	local GITVERSIONFUSE=$(go list -m github.com/hanwen/go-fuse/v2 | cut -d' ' -f2-)
	local GO_LDFLAGS="-extldflags=-Wl,-rpath=$TERMUX_PREFIX/lib"
	GO_LDFLAGS+=" -X \"main.GitVersion=v${TERMUX_PKG_VERSION#*really}\""
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
