TERMUX_PKG_HOMEPAGE=https://pagure.io/mlocate
TERMUX_PKG_DESCRIPTION="Tool to find files anywhere in the filesystem based on their name"
TERMUX_PKG_LICENSE="GPL-2.0"
# If not linking to libandroid-support we segfault in
# the libc mbsnrtowcs() function when using a wildcard
# like in '*.deb'.
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_VERSION=0.26
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://releases.pagure.org/mlocate/mlocate-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3063df79fe198fb9618e180c54baf3105b33d88fe602ff2d8570aaf944f1263e

termux_step_pre_configure() {
	CPPFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p $TERMUX_PREFIX/var/mlocate/" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
