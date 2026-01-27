# Contributor: @Neo-Oli
TERMUX_PKG_HOMEPAGE=https://github.com/Parchive/par2cmdline
TERMUX_PKG_DESCRIPTION="par2cmdline is a PAR 2.0 compatible file verification and repair tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL=https://github.com/Parchive/par2cmdline/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=61d51a6e9b14375d067a1e8b58f801c22287e8a443868383763defe7abadd7ab
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
