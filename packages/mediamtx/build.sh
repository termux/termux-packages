TERMUX_PKG_HOMEPAGE=https://github.com/bluenviron/mediamtx
TERMUX_PKG_DESCRIPTION="Ready-to-use SRT / WebRTC / RTSP / RTMP / LL-HLS media server and media proxy"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.1"
TERMUX_PKG_SRCURL=https://github.com/bluenviron/mediamtx/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a698dedf6f9b0e2801ab5d86720fcf79e0cc54d7b94c0fc1a70aab69ac69129
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	termux_setup_golang
	go generate ./...
}

termux_step_make() {
	termux_setup_golang
	echo "v${TERMUX_PKG_VERSION}" > "${TERMUX_PKG_SRCDIR}"/internal/core/VERSION
	export GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw"

	# -checklinkname=0 for https://github.com/wlynxg/anet?tab=readme-ov-file#how-to-build-with-go-1230-or-later
	go build -ldflags='-checklinkname=0 -s -w -linkmode=external'
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin mediamtx
	install -Dm600 -t "${TERMUX_PREFIX}"/etc/mediamtx mediamtx.yml
}
