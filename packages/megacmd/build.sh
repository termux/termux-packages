TERMUX_PKG_HOMEPAGE="https://github.com/meganz/MEGAcmd"
TERMUX_PKG_DESCRIPTION="Command Line Interactive and Scriptable Application to access MEGA Resources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@MrAdityaAlok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/meganz/MEGAcmd/archive/${TERMUX_PKG_VERSION}_Linux.tar.gz"
TERMUX_PKG_SHA256=2a3626a9f1d22303fe2123f984a8ecf3779d6d59ac6c67c1bf43c2423dcb832d
TERMUX_PKG_DEPENDS="cryptopp, zlib, libsqlite, c-ares, libuv, openssl, curl, libsodium, readline, pcre"
TERMUX_PKG_SUGGESTS="ffmpeg"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sh autogen.sh
}
