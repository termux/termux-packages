TERMUX_PKG_HOMEPAGE=https://pocoproject.org/
TERMUX_PKG_DESCRIPTION="A comprehensive set of C++ libraries that cover all modern-day programming needs"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.5"
TERMUX_PKG_SRCURL=https://github.com/pocoproject/poco/archive/refs/tags/poco-${TERMUX_PKG_VERSION}-release.tar.gz
TERMUX_PKG_SHA256=92b18eb0fcd2263069f03e7cc80f9feb43fb7ca23b8c822a48e42066b2cd17a6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='(?<=-)[^-]+(?=-)'
TERMUX_PKG_DEPENDS="libc++, libexpat, libsqlite, openssl, pcre2, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPOCO_UNBUNDLED=ON"
