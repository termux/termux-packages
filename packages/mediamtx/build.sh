TERMUX_PKG_HOMEPAGE=https://github.com/bluenviron/mediamtx
TERMUX_PKG_DESCRIPTION="Ready-to-use SRT / WebRTC / RTSP / RTMP / LL-HLS media server and media proxy"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.0"
TERMUX_PKG_SRCURL=https://github.com/bluenviron/mediamtx/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f362573d818e9096ab2b5b8cbe6bcb392536b1f12faf0660135b44cc9e084627
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
