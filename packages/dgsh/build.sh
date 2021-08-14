TERMUX_PKG_HOMEPAGE=https://www.spinellis.gr/sw/dgsh/
TERMUX_PKG_DESCRIPTION="Directed Graph Shell"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL="https://github.com/dspinellis/dgsh/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=22a7f2794e1287a46b03ce38c27a1d9349d1c66535c30e065c8783626555c76c
TERMUX_PKG_BUILD_DEPENDS="autoconf,automake,pkg-config,libtool,check,bison,git,gettext,gperf,perl,texinfo,help2man,ncurses"
# TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/core-tools"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--host=$TERMUX_HOST_PLATFORM"

# termux_step_pre_configure() {
#     autoreconf -vfi
# }
