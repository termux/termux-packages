TERMUX_PKG_HOMEPAGE=http://www.figlet.org/
TERMUX_PKG_DESCRIPTION="Program for making large letters out of ordinary text"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=2.2.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf88c40fd0f077dab2712f54f8d39ac952e4e9f2e1882f1195be9e5e4257417d
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LD=$CC
}
