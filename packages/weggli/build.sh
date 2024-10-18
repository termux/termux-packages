TERMUX_PKG_HOMEPAGE="https://github.com/googleprojectzero/weggli"
TERMUX_PKG_DESCRIPTION="A fast and robust semantic search tool for C and C++ codebases"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/googleprojectzero/weggli/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=12fde9a0dca2852d5f819eeb9de85c4d11c5c384822f93ac66b2b7b166c3af78
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	mv pyproject.toml{,.unused}
	mv setup.py{,.unused}
}

termux_step_pre_configure() {
	# error: version script assignment of 'global' to symbol '__muloti4' failed: symbol not defined
	RUSTFLAGS+=" -C link-arg=-Wl,--undefined-version"
}
