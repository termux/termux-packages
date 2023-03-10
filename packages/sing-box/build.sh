TERMUX_PKG_HOMEPAGE=https://sing-box.sagernet.org
TERMUX_PKG_DESCRIPTION="The universal proxy platform"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION="1.2-beta8"
TERMUX_PKG_SRCURL="https://github.com/SagerNet/sing-box/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=dd2e843cbb9698f32ececd946d5f0a414977bc92f605f50b60f424bf7a5bee56
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	local tags="with_quic,with_grpc,with_dhcp,with_wireguard,with_shadowsocksr,with_ech,with_utls,with_reality_server,with_clash_api,with_gvisor"
	local ldflags="\
	-w -s \
	-X 'github.com/sagernet/sing-box/constant.Version=${TERMUX_PKG_VERSION}' \
	"

	export CGO_ENABLED=1

	go build \
		-trimpath \
		-tags "${tags}" \
		-ldflags="${ldflags}" \
		-o "${TERMUX_PKG_NAME}" \
		./cmd/sing-box

}

termux_step_make_install() {
	install -Dm700 ./${TERMUX_PKG_NAME} ${TERMUX_PREFIX}/bin
}
