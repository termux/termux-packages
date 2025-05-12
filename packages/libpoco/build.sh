TERMUX_PKG_HOMEPAGE=https://pocoproject.org/
TERMUX_PKG_DESCRIPTION="A comprehensive set of C++ libraries that cover all modern-day programming needs"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.2"
TERMUX_PKG_SRCURL=https://github.com/pocoproject/poco/archive/refs/tags/poco-${TERMUX_PKG_VERSION}-release.tar.gz
TERMUX_PKG_SHA256=47394ea7ddb7b0a40e1a5be896f8f5dc77cfdc4f561d2e7131ecf582df5a0c3a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='(?<=-)[^-]+(?=-)'
TERMUX_PKG_DEPENDS="libc++, libexpat, libsqlite, openssl, pcre2, utf8proc, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPOCO_UNBUNDLED=ON"
