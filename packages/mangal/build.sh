TERMUX_PKG_HOMEPAGE=https://github.com/metafates/mangal
TERMUX_PKG_DESCRIPTION="Cli manga downloader"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.6"
TERMUX_PKG_SRCURL=git+https://github.com/metafates/mangal
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy 
}

termux_step_make() {
	go build -o mangal
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin mangal
}
