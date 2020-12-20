TERMUX_PKG_HOMEPAGE=https://mosh.org
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_REVISION=27
TERMUX_PKG_SRCURL=https://github.com/mobile-shell/mosh/releases/download/mosh-${TERMUX_PKG_VERSION}/mosh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libprotobuf, ncurses, openssl, openssh"

termux_step_pre_configure() {
	termux_setup_protobuf
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin
	mv mosh mosh.pl
	$CXX $CXXFLAGS $LDFLAGS \
		-isystem $TERMUX_PREFIX/include \
		-DPACKAGE_VERSION=\"$TERMUX_PKG_VERSION\" \
		-std=c++11 -Wall -Wextra -Werror \
		$TERMUX_PKG_BUILDER_DIR/mosh.cc -o mosh
}
