TERMUX_PKG_HOMEPAGE=https://tinyproxy.github.io/
TERMUX_PKG_DESCRIPTION="Light-weight HTTP proxy daemon for POSIX operating systems"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.2
TERMUX_PKG_SRCURL=https://github.com/tinyproxy/tinyproxy/releases/download/${TERMUX_PKG_VERSION}/tinyproxy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6a126880706691c987e2957b1c99b522efb1964a75eb767af4b30aac0b88a26a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-regexcheck"

termux_step_pre_configure() {
	CPPFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
}

termux_step_post_massage() {
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/log/${TERMUX_PKG_NAME}"
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/run/${TERMUX_PKG_NAME}"
}
