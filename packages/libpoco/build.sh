TERMUX_PKG_HOMEPAGE=https://pocoproject.org/
TERMUX_PKG_DESCRIPTION="A comprehensive set of C++ libraries that cover all modern-day programming needs"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.1
TERMUX_PKG_SRCURL=https://github.com/pocoproject/poco/archive/refs/tags/poco-${TERMUX_PKG_VERSION}-release.tar.gz
TERMUX_PKG_SHA256=2412a5819a239ff2ee58f81033bcc39c40460d7a8b330013a687c8c0bd2b4ac0
TERMUX_PKG_DEPENDS="libc++, libexpat, openssl, pcre, sqlite, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPOCO_UNBUNDLED=ON"
