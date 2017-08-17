TERMUX_PKG_HOMEPAGE=https://github.com/Parchive/par2cmdline
TERMUX_PKG_DESCRIPTION="par2cmdline is a PAR 2.0 compatible file verification and repair tool."
TERMUX_PKG_VERSION=0.7.3
TERMUX_PKG_SHA256=3d97992b6d2bf5acc0b07a4e43c70713ac41606fa911e1eea3ac702558561c37
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/Parchive/par2cmdline/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=par2cmdline-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "i686" ]; then
		sed -i 's/LDADD = -lstdc++/LDADD = -lstdc++ -latomic/' $TERMUX_PKG_SRCDIR/Makefile.am
	fi
	aclocal
	automake --add-missing
	autoconf
}
