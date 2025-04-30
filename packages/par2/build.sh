TERMUX_PKG_HOMEPAGE=https://github.com/Parchive/par2cmdline
TERMUX_PKG_DESCRIPTION="par2cmdline is a PAR 2.0 compatible file verification and repair tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL=https://github.com/Parchive/par2cmdline/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f17b4fd6812852d86b500823bd8d430d754e9189f3f4213b898a3652866116f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid undefined reference to __atomic_* functions:
		export LIBS=" -latomic"
	fi
	LDFLAGS+=" -fopenmp -static-openmp"
	aclocal
	automake --add-missing
	autoconf
}
