TERMUX_PKG_HOMEPAGE=http://www.figlet.org/
TERMUX_PKG_DESCRIPTION="Program for making large letters out of ordinary text"
TERMUX_PKG_VERSION=2.2.5
TERMUX_PKG_SRCURL=ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	LD=$CC
}
