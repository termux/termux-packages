TERMUX_PKG_HOMEPAGE=https://github.com/charmbracelet/freeze
TERMUX_PKG_DESCRIPTION="Generate images of code and terminal output."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Veha0001"
TERMUX_PKG_VERSION="0.2.2"
TERMUX_PKG_SRCURL=https://github.com/charmbracelet/freeze/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0e959bc0c83c0a00d9da8362ca0d928191ad3207fc542c757e9eddda4014e08
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go build -trimpath -ldflags="-s -w -X main.Version=${TERMUX_PKG_VERSION}"
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin freeze
}
