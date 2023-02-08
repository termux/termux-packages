TERMUX_PKG_HOMEPAGE=https://github.com/shaunmulligan/quine-runtime
TERMUX_PKG_DESCRIPTION="Runtime scripts and config for quineOS"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@shaunmulligan"
TERMUX_PKG_VERSION=0.0.1
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=git+https://github.com/shaunmulligan/quine-runtime.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_AUTO_UPDATE=true


termux_step_make() {
	# Setting up QuineOS runtime files
    echo "Setting up quineOS"
}

termux_step_make_install() {
	install -Dm 777 ${TERMUX_PKG_SRCDIR}/test.sh ${TERMUX_PREFIX}/opt/test.sh
}