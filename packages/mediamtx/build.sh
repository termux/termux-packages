TERMUX_PKG_HOMEPAGE=https://github.com/bluenviron/mediamtx
TERMUX_PKG_DESCRIPTION="Ready-to-use SRT / WebRTC / RTSP / RTMP / LL-HLS media server and media proxy"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.3"
TERMUX_PKG_SRCURL=https://github.com/bluenviron/mediamtx/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8da9b083952ca384882b11f9067810c605628cf9c2c61a3c1bc68be16a2fb71e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_host_build() {
	termux_setup_golang
	pushd "${TERMUX_PKG_SRCDIR}"
	go generate ./...
	popd
}

termux_step_make() {
	echo "v${TERMUX_PKG_VERSION}" > "${TERMUX_PKG_SRCDIR}"/internal/core/VERSION
	export GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw"
	go build -ldflags='-s -w -linkmode=external'
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin mediamtx
	install -Dm600 -t "${TERMUX_PREFIX}"/etc/mediamtx mediamtx.yml
}
