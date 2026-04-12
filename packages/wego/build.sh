TERMUX_PKG_HOMEPAGE=https://github.com/schachmat/wego
TERMUX_PKG_DESCRIPTION="weather app for the terminal"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4"
TERMUX_PKG_SRCURL="https://github.com/schachmat/wego/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5ae1c76a322ff2e295034a801755c42b0cb6bdef5ab205af42cf95dbf7c570f4
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -o wego
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin wego
}
