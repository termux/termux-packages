TERMUX_PKG_HOMEPAGE=https://pocoproject.org/
TERMUX_PKG_DESCRIPTION="A comprehensive set of C++ libraries that cover all modern-day programming needs"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.5p1"
TERMUX_PKG_SRCURL=https://github.com/pocoproject/poco/archive/refs/tags/poco-${TERMUX_PKG_VERSION}-release.tar.gz
TERMUX_PKG_SHA256=8ba10b69c815e95e1c8776af0143aa8603088b84e3f6a8447994c6b92d7522f0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='(?<=-)[^-]+(?=-)'
TERMUX_PKG_DEPENDS="libc++, libexpat, libsqlite, openssl, pcre2, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPOCO_UNBUNDLED=ON"
