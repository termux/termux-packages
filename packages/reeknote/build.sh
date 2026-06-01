TERMUX_PKG_HOMEPAGE=https://gitlab.com/vitaly-zdanevich/reeknote
TERMUX_PKG_DESCRIPTION="Command-line Evernote client written in Rust"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Vitaly Zdanevich <zdanevich.vitaly@ya.ru>"
TERMUX_PKG_VERSION=0.8.4
TERMUX_PKG_SRCURL=https://gitlab.com/vitaly-zdanevich/reeknote/-/archive/${TERMUX_PKG_VERSION}/reeknote-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4018e88db2ba358178e6ab2e2aa9cedcde966bd69d7523056cd25f15ca386b41
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--bins"
TERMUX_PKG_SUGGESTS="mpv"

termux_step_pre_configure() {
	termux_setup_rust
}
