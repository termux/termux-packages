TERMUX_PKG_HOMEPAGE=https://pressly.github.io/goose
TERMUX_PKG_DESCRIPTION="A database migration tool. Supports SQL migrations and Go functions."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.22.0"
TERMUX_PKG_SRCURL="https://github.com/pressly/goose/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c624faf209caa6d666059882904a4fc90be6e225aeede0cd063bb4b6aa365c90
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
