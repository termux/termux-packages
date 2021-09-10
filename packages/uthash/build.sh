TERMUX_PKG_HOMEPAGE=https://troydhanson.github.io/uthash/
TERMUX_PKG_DESCRIPTION="C preprocessor implementations of a hash table and a linked list"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/troydhanson/uthash/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e10382ab75518bad8319eb922ad04f907cb20cccb451a3aa980c9d005e661acc
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cd src
	install -Dm600 -t $TERMUX_PREFIX/include *.h
}
