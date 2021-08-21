TERMUX_PKG_HOMEPAGE="https://github.com/meganz/MEGAcmd"
TERMUX_PKG_DESCRIPTION="Command Line Interactive and Scriptable Application to access MEGA Resources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@MrAdityaAlok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}_Linux"
TERMUX_PKG_SRCURL="https://github.com/meganz/MEGAcmd.git"
TERMUX_PKG_DEPENDS="cryptopp, zlib, libsqlite, c-ares, libuv, openssl, curl, libsodium, readline, pcre, freeimage,ffmpeg, libmediainfo"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sh autogen.sh
}
