TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/recutils/
TERMUX_PKG_DESCRIPTION="Set of tools and libraries to access human-editable, plain text databases called recfiles"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Rowan Wookey <admin@rwky.net>"
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/recutils/recutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=df8eae69593fdba53e264cbf4b2307dfb82120c09b6fab23e2dad51a89a5b193
# Prevent libandroid-spawn from being picked up
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_spawn_h=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="lispdir=${TERMUX_PREFIX}/share/emacs/site-lisp"
