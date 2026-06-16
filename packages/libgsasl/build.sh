TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gsasl
TERMUX_PKG_DESCRIPTION="GNU SASL library"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.4"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gsasl/gsasl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d32be15efd3a04cb19b232f721bdca02cc6ad7ab415df7d79fb2dd2c0da3e0be
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libidn"
TERMUX_PKG_BREAKS="libgsasl-dev"
TERMUX_PKG_REPLACES="libgsasl-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_getpass=yes
--without-libgcrypt
"
