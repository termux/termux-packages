TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/cunit/
TERMUX_PKG_DESCRIPTION="C Unit Testing Framework"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Thibault Meyer <meyer.thibault@gmail.com>"
TERMUX_PKG_VERSION=2.1.3
_VERSION=$(echo "$TERMUX_PKG_VERSION" | sed -E 's/(.*)\./\1-/')
TERMUX_PKG_SRCURL=https://github.com/Linaro/libcunit/releases/download/${_VERSION}/CUnit-${_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f5b29137f845bb08b77ec60584fdb728b4e58f1023e6f249a464efa49a40f214
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-automated
--enable-basic
--enable-console
"

termux_step_pre_configure() {
	libtoolize --force --copy
	aclocal
	autoheader
	automake --add-missing --include-deps --copy
	autoconf
}
