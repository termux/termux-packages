TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/recutils/
TERMUX_PKG_DESCRIPTION="Set of tools and libraries to access human-editable, plain text databases called recfiles"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/recutils/recutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6301592b0020c14b456757ef5d434d49f6027b8e5f3a499d13362f205c486e0e
# Prevent libandroid-spawn from being picked up
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_spawn_h=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="lispdir=${TERMUX_PREFIX}/share/emacs/site-lisp"
