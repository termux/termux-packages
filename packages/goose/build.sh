TERMUX_PKG_HOMEPAGE=https://pressly.github.io/goose
TERMUX_PKG_DESCRIPTION="A database migration tool. Supports SQL migrations and Go functions."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.23.1"
TERMUX_PKG_SRCURL="https://github.com/pressly/goose/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0db063acea1ebc6fd205159028dab8bcdcb731e82fdeb4c6d4b2383783a16edf
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
	go mod tidy
}

termux_step_make() {
	go build -o goose ./cmd/goose
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin goose
}

termux_step_install_license() {
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/LICENSE"
}
