TERMUX_PKG_HOMEPAGE=https://boinc.berkeley.edu/
TERMUX_PKG_DESCRIPTION=" Open-source software for volunteer computing "
TERMUX_PKG_MAJOR_VERSION=7.4
TERMUX_PKG_VERSION=${TERMUX_PKG_MAJOR_VERSION}.52
TERMUX_PKG_SRCURL=https://github.com/BOINC/boinc/archive/client_release/${TERMUX_PKG_MAJOR_VERSION}/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=boinc-client_release-7.4-7.4.52
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-server --enable-client --disable-manager CPPFLAGS=-DANDROID LDFLAGS=-llog --sysconfdir=${TERMUX_PREFIX}/etc/"
TERMUX_PKG_DEPENDS="libcurl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
    cd ${TERMUX_PKG_SRCDIR}
    ./_autosetup
}
