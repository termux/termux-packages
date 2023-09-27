TERMUX_PKG_HOMEPAGE=https://github.com/sass/libsass
TERMUX_PKG_DESCRIPTION="Sass compiler written in C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.5
TERMUX_PKG_SRCURL=https://github.com/sass/libsass/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=89d8f2c46ae2b1b826b58ce7dde966a176bac41975b82e84ad46b01a55080582
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -fi

	if [ "${TERMUX_PKG_SRCURL:0:4}" != "git+" ] && [ ! -e VERSION ]; then
		echo "${TERMUX_PKG_VERSION#*:}" > VERSION
	fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
