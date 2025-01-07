TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/sharutils/
TERMUX_PKG_DESCRIPTION="Utilities for packaging and unpackaging shell archives"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.15.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/sharutils/sharutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2b05cff7de5d7b646dc1669bc36c35fdac02ac6ae4b6c19cb3340d87ec553a9a
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_spawn_h=no
"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU"
}
