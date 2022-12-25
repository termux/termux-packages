TERMUX_PKG_HOMEPAGE=https://github.com/42wim/matterbridge
TERMUX_PKG_DESCRIPTION="A simple chat bridge"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.25.2"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/42wim/matterbridge/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e078a4776b1082230ea0b8146613679c23d3b0d322706c987261df987a04bfc5
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="binutils-cross"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = arm ]; then
		termux_setup_no_integrated_as
	fi

	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -tags whatsappmulti
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin matterbridge
}
