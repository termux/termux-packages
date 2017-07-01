TERMUX_PKG_HOMEPAGE=https://mosh.org
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mobile-shell/mosh/releases/download/mosh-${TERMUX_PKG_VERSION}/mosh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=320e12f461e55d71566597976bd9440ba6c5265fa68fbf614c6f1c8401f93376
TERMUX_PKG_FOLDERNAME=mosh-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libandroid-support, libprotobuf, ncurses, openssl, openssh, libutil"

termux_step_pre_configure () {
	export PROTOC=$TERMUX_TOPDIR/libprotobuf/host-build/src/protoc
}

termux_step_post_make_install () {
	cd $TERMUX_PREFIX/bin
	mv mosh mosh.pl
	$CXX $CXXFLAGS $LDFLAGS \
		-isystem $TERMUX_PREFIX/include \
		-lutil \
		-DPACKAGE_VERSION=\"$TERMUX_PKG_VERSION\" \
		-std=c++11 -Wall -Wextra -Werror \
		$TERMUX_PKG_BUILDER_DIR/mosh.cc -o mosh
}
