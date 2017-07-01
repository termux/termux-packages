TERMUX_PKG_HOMEPAGE=https://github.com/Parchive/par2cmdline
TERMUX_PKG_DESCRIPTION="par2cmdline is a PAR 2.0 compatible file verification and repair tool."
TERMUX_PKG_VERSION=0.7.1
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/Parchive/par2cmdline/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=894e798eeffa4d96542aa437a8ca2b74406b7f831a56c6f7fd67d45e2548552c
TERMUX_PKG_FOLDERNAME=par2cmdline-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	aclocal
	automake --add-missing
	autoconf
}
