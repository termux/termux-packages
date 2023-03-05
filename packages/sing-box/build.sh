TERMUX_PKG_HOMEPAGE=https://sing-box.sagernet.org
TERMUX_PKG_DESCRIPTION="The universal proxy platform"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION="1.2-beta5"
TERMUX_PKG_SRCURL="https://github.com/SagerNet/sing-box/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=14a5834b9cde1c7e951c5d65ddf3c660b56cde76de4fff43f5454c9549f6ee82
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
