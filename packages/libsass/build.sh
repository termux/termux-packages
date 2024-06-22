TERMUX_PKG_HOMEPAGE=https://github.com/sass/libsass
TERMUX_PKG_DESCRIPTION="Sass compiler written in C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.6.6"
TERMUX_PKG_SRCURL=https://github.com/sass/libsass/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=11f0bb3709a4f20285507419d7618f3877a425c0131ea8df40fe6196129df15d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -fi

	if [ "${TERMUX_PKG_SRCURL:0:4}" != "git+" ] && [ ! -e VERSION ]; then
		echo "${TERMUX_PKG_VERSION#*:}" > VERSION
	fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
