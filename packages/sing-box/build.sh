TERMUX_PKG_HOMEPAGE=https://sing-box.sagernet.org
TERMUX_PKG_DESCRIPTION="The universal proxy platform"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION="1.2-beta7"
TERMUX_PKG_SRCURL="https://github.com/SagerNet/sing-box/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f0c6d438fff54ac5dc0ff8ef01a2a016dc9dc8a6dd7e428fe7546d38daaa6e63
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	local tags="with_quic,with_grpc,with_dhcp,with_wireguard,with_shadowsocksr,with_ech,with_utls,with_reality_server,with_clash_api,with_gvisor"

	export CGO_ENABLED=1

	go build \
		-trimpath \
		-tags "$tags" \
		-ldflags "-s -w -buildid='" \
		-o "sing-box" \
		./cmd/sing-box

}

termux_step_make_install() {
	install -Dm700 ./sing-box ${TERMUX_PREFIX}/bin
}
