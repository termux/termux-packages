TERMUX_PKG_HOMEPAGE=https://github.com/Dreamacro/clash
TERMUX_PKG_DESCRIPTION="A rule-based tunnel in Go"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Philipp Schmitt <philipp@schmitt.co>"
TERMUX_PKG_VERSION="1.13.0"
TERMUX_PKG_SRCURL="https://github.com/Dreamacro/clash/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=dcef53df90d39e150f8da2f96edbf09d29b769ac89ea968699189f3f7ef15f60
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	mkdir ./gopath
	export GOPATH="$PWD/gopath"

	GOBUILD=CGO_ENABLED=0 \
		go build \
			-trimpath \
			-ldflags "-X 'github.com/Dreamacro/clash/constant.Version=${TERMUX_PKG_VERSION}'
								-X 'github.com/Dreamacro/clash/constant.BuildTime=$(date -u)'
								-w -s -buildid='" \
			-o "clash.bin" \
			main.go
}

termux_step_make_install() {
	mv ./clash.bin "${TERMUX_PREFIX}/bin/clash"
}
