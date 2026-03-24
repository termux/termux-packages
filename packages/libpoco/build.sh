TERMUX_PKG_HOMEPAGE=https://pocoproject.org/
TERMUX_PKG_DESCRIPTION="A comprehensive set of C++ libraries that cover all modern-day programming needs"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.15.1"
TERMUX_PKG_SRCURL=https://github.com/pocoproject/poco/archive/refs/tags/poco-${TERMUX_PKG_VERSION}-release.tar.gz
TERMUX_PKG_SHA256=e9e2bf46797cb2285299922fa881b670a25da4cfe09f1b97b479c63f7883639a
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libc++, libexpat, libsqlite, openssl, pcre2, utf8proc, zlib"
TERMUX_PKG_BUILD_DEPENDS="libpng"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPOCO_UNBUNDLED=ON"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+(?=-release)'

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-posix-semaphore"
}
