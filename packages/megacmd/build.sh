TERMUX_PKG_HOMEPAGE="https://github.com/meganz/MEGAcmd"
TERMUX_PKG_DESCRIPTION="Command Line Interactive and Scriptable Application to access MEGA Resources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@MrAdityaAlok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION="1.4.0"
_MEGA_SDK_VERSION="3.8.2c"
TERMUX_PKG_DEPENDS="cryptopp, zlib, libsqlite, c-ares, libuv, openssl, curl, libsodium, pcre, freeimage, ffmpeg, libmediainfo, libzen, ncurses, readline"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-examples
"

termux_step_get_source() {
	termux_download "https://github.com/meganz/MEGAcmd/archive/${TERMUX_PKG_VERSION}_Linux.tar.gz" \
		"${TERMUX_PKG_CACHEDIR}/mega-${TERMUX_PKG_VERSION}_Linux.tar.gz" \
		2a3626a9f1d22303fe2123f984a8ecf3779d6d59ac6c67c1bf43c2423dcb832d
	termux_download "https://github.com/meganz/sdk/archive/v${_MEGA_SDK_VERSION}.tar.gz" \
		"${TERMUX_PKG_CACHEDIR}/mega-sdk-${_MEGA_SDK_VERSION}.tar.gz" \
		50d3c7ec8bf0b8dddadda3715530fb2e4a6d867c93faa2c6cffdbb6ea868eea3

	mkdir -p "${TERMUX_PKG_SRCDIR}"
}

termux_step_pre_configure() {
	tar -xf "${TERMUX_PKG_CACHEDIR}/mega-${TERMUX_PKG_VERSION}_Linux.tar.gz"
	cd "MEGAcmd-${TERMUX_PKG_VERSION}_Linux/"

	mkdir -p sdk
	tar -xf "${TERMUX_PKG_CACHEDIR}/mega-sdk-${_MEGA_SDK_VERSION}.tar.gz"
	mv "sdk-${_MEGA_SDK_VERSION}"/* sdk

	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/MEGAcmd-${TERMUX_PKG_VERSION}_Linux"

	sh autogen.sh
}
