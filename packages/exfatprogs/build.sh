TERMUX_PKG_HOMEPAGE=https://github.com/exfatprogs/exfatprogs.git
TERMUX_PKG_DESCRIPTION="exFAT filesystem userspace utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Shadichy"
TERMUX_PKG_VERSION="1.2.8"
TERMUX_PKG_SRCURL=git+https://github.com/exfatprogs/exfatprogs.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PROVIDES=exfatprogs
TERMUX_PKG_CONFLICTS=exfatprogs-google

termux_step_pre_configure() {
    ./autogen.sh
}
