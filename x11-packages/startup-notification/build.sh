TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Utility libraries for XC Binding"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.12
TERMUX_PKG_REVISION=25
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/startup-notification/releases/startup-notification-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a
TERMUX_PKG_DEPENDS="libx11, libxcb, xcb-util"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="lf_cv_sane_realloc=yes"
