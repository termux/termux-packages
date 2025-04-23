TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/external/exfatprogs
TERMUX_PKG_DESCRIPTION="exFAT filesystem userspace utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Shadichy"
TERMUX_PKG_VERSION="1.2.1"
TERMUX_PKG_SRCURL=git+https://android.googlesource.com/platform/external/exfatprogs
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PROVIDES=exfatprogs
TERMUX_PKG_CONFLICTS=exfatprogs

termux_step_pre_configure() {
    ./autogen.sh
    CFLAGS+=" -D_FILE_OFFSET_BITS=64"
    CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
}
