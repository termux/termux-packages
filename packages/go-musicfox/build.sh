TERMUX_PKG_HOMEPAGE=https://github.com/go-musicfox/go-musicfox
TERMUX_PKG_DESCRIPTION="A netease music player in terminal."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@anhoder"
TERMUX_PKG_VERSION="4.5.6"
TERMUX_PKG_DEPENDS="libc++, libflac, libvorbis"
TERMUX_PKG_SRCURL=https://github.com/go-musicfox/go-musicfox/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a22d528477539f6b2882c128ce7884f8b1285e3ac76a9cf515baa2f9c855b933
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	GIT_TAG="v${TERMUX_PKG_VERSION}" make build
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/bin/musicfox
}
