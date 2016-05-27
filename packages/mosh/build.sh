TERMUX_PKG_HOMEPAGE=http://mosh.mit.edu/
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
TERMUX_PKG_VERSION=1.2.5.20160523
TERMUX_PKG_SRCURL=http://mosh.mit.edu/mosh-${TERMUX_PKG_VERSION}.tar.gz
_COMMIT=05fe24d50ddbabf1c87be748b7397907ae1b9654
TERMUX_PKG_SRCURL=https://github.com/mobile-shell/mosh/archive/${_COMMIT}.zip
TERMUX_PKG_FOLDERNAME=mosh-${_COMMIT}

TERMUX_PKG_DEPENDS="libandroid-support, protobuf, ncurses, openssl, openssh, libutil, libgnustl"

export PROTOC=$TERMUX_TOPDIR/protobuf/host-build/src/protoc

LDFLAGS+=" -lgnustl_shared"

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
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
