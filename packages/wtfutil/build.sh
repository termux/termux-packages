TERMUX_PKG_HOMEPAGE=https://wtfutil.com/
TERMUX_PKG_DESCRIPTION="The personal information dashboard for your terminal"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.43.0
# Need metadata in Git repository
TERMUX_PKG_SRCURL=git+https://github.com/wtfutil/wtf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -o wtfutil
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin wtfutil
}
