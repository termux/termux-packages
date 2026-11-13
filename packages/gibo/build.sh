TERMUX_PKG_HOMEPAGE=https://github.com/simonwhitaker/gibo
TERMUX_PKG_DESCRIPTION="Easy access to gitignore boilerplates"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION=3.0.23
TERMUX_PKG_SRCURL="https://github.com/simonwhitaker/gibo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a529ad07de46728eafe3aecf01612128bee23ec8a856ad6484e94a21c98dd9e8
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go install .
	go build .
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin gibo
}
