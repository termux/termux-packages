TERMUX_PKG_HOMEPAGE=https://github.com/Parchive/par2cmdline
TERMUX_PKG_DESCRIPTION="par2cmdline is a PAR 2.0 compatible file verification and repair tool."
TERMUX_PKG_VERSION=0.6.14
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/Parchive/par2cmdline/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2fd831ba924d9f0ecd9242ca45551b6995ede1ed281af79aa30e7490d5596e7a
TERMUX_PKG_FOLDERNAME=par2cmdline-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	aclocal
	automake --add-missing
	autoconf
}
