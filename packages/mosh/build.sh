TERMUX_PKG_HOMEPAGE=http://mosh.mit.edu/
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
TERMUX_PKG_VERSION=1.2.5.20160402
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://mosh.mit.edu/mosh-${TERMUX_PKG_VERSION}.tar.gz
_COMMIT=f30738e3256e90850e945c08624fce90b1ba78a1
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
	# Avoid env and specify perl directly:
	sed -i'' '1 s|^.*$|#! /bin/perl|' $TERMUX_PREFIX/bin/mosh
	cd $TERMUX_PREFIX/bin
	mv mosh mosh.pl
	ln -s mosh-cfront mosh
}
