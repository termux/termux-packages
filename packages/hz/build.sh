TERMUX_PKG_HOMEPAGE=https://www.cloudwego.io
TERMUX_PKG_DESCRIPTION="A high-performance and strong-extensibility Go HTTP framework that helps developers build microservices"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.5"
TERMUX_PKG_SRCURL=https://github.com/cloudwego/hertz/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=727da59f413c8739e467a13ebef3e580fb2b80640707c8417cd388b900af8780
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	cd "$TERMUX_PKG_SRCDIR"/cmd/hz

	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"/cmd/hz
	go build -o hz
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/cmd/hz/hz
}
