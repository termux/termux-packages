TERMUX_PKG_HOMEPAGE="https://oils.pub/"
TERMUX_PKG_DESCRIPTION="Bash-compatible Unix shell with more consistent syntax and semantics"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION="0.38.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://oils.pub/download/oils-for-unix-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="a33453722819b55ee552bfd7f3c2bab8f1940def55d5c8b46af16ce95bdf8803"
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, readline"
TERMUX_PKG_CONFLICTS="oils"
TERMUX_PKG_REPLACES="oils"
TERMUX_PKG_PROVIDES="oils"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	_OIL_DEV=1 \
	./configure \
		--cxx-for-configure "${CXX}" \
		--prefix "${TERMUX__PREFIX}" \
		--datarootdir "${TERMUX__PREFIX__SHARE_DIR}" \
		--with-readline \
		--readline "${TERMUX__PREFIX}"
}

termux_step_make() {
	LDFLAGS+=" -landroid-glob"
	_build/oils.sh --cxx "${CXX}"
}

termux_step_make_install() {
	./install "_bin/${CXX}-opt-sh/oils-for-unix"
}
