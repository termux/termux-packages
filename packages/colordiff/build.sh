TERMUX_PKG_HOMEPAGE=http://www.colordiff.org
TERMUX_PKG_DESCRIPTION="The Perl script colordiff is a wrapper for 'diff' and produces the same output but with pretty 'syntax' highlighting."
TERMUX_PKG_VERSION=1.0.16
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=http://www.colordiff.org/colordiff-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_pre_make(){
	export INSTALL_DIR=${PREFIX}/bin
	export MAN_DIR=${PREFIX}/share/man/man1
	export ETC_DIR=${PREFIX}/etc
}
