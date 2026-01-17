TERMUX_PKG_HOMEPAGE=https://nheko.im/nheko-reborn/coeurl
TERMUX_PKG_DESCRIPTION="Simple library to do http requests asynchronously via CURL in C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.0"
TERMUX_PKG_SRCURL="https://nheko.im/nheko-reborn/coeurl/-/archive/v${TERMUX_PKG_VERSION}/coeurl-v${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=a80f0cb449df5719c70ce34a00a95191c1e27f79ec6bef1e72be5d4d97c95f9d
TERMUX_PKG_DEPENDS="fmt, libc++, libcurl, libevent, libspdlog"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# Upstream insists on using Meson
	rm -f CMakeLists.txt

	# Remove broken warp files
	rm -r subprojects
}
