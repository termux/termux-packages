TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/autoconf/autoconf.html
TERMUX_PKG_DESCRIPTION="Creator of shell scripts to configure source code packages"
TERMUX_PKG_VERSION=2.69
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/autoconf/autoconf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="m4, make, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_post_extract_package () {
	cd $TERMUX_PKG_SRCDIR
	perl -p -i -e "s|/bin/sh|$TERMUX_PREFIX/bin/sh|" lib/*/*.m4
}

termux_step_post_massage () {
	perl -p -i -e "s|/usr/bin/m4|$TERMUX_PREFIX/bin/m4|" bin/*
	perl -p -i -e "s|CONFIG_SHELL-/bin/sh|CONFIG_SHELL-$TERMUX_PREFIX/bin/sh|" bin/autoconf 
}
