TERMUX_PKG_HOMEPAGE=http://w3m.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Text based Web browser and pager"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.5.3
_MINOR_VERSION=20190105
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.${_MINOR_VERSION}
TERMUX_PKG_REVISION=8
# The upstream w3m project is dead, but every linux distribution uses
# this maintained fork in debian:
TERMUX_PKG_SRCURL=https://github.com/tats/w3m/archive/v${_MAJOR_VERSION}+git${_MINOR_VERSION}.tar.gz
TERMUX_PKG_SHA256=0467bb5429b75749205a3f57b9f5e8abba49929272aeab6fce94ff17953f0784
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libgc, ncurses, openssl, zlib"
TERMUX_PKG_SUGGESTS="perl"

# ac_cv_func_bcopy=yes to avoid w3m defining it's own bcopy function, which
# breaks 64-bit builds where NDK headers define bcopy as a macro:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes ac_cv_func_bcopy=yes"

#Overwrite the default /usr/bin/firefox with termux-open-url as default external browser. That way, pressing "M" on a URL will open a link in Androids default Browser.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-browser=termux-open-url"
#Overwrite the default editor to just vi, as the default was /usr/bin/vi.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-editor=nano"
# Build w3mimg with X11/imlib2.
# w3mimgdisplay is in w3m-img subpackage.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-image=x11 --with-imagelib=imlib2"

# For Makefile.in.patch:
export TERMUX_PKG_BUILDER_DIR
