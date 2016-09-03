TERMUX_PKG_HOMEPAGE=https://fedorahosted.org/mlocate/
TERMUX_PKG_DESCRIPTION="Tool to find files anywhere in the filesystem based on their name"
TERMUX_PKG_VERSION=0.26
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=https://fedorahosted.org/releases/m/l/mlocate/mlocate-${TERMUX_PKG_VERSION}.tar.xz

termux_step_pre_configure() {
	CPPFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
}

termux_step_create_debscripts () {
        echo "mkdir -p $TERMUX_PREFIX/var/mlocate/" > postinst
        echo "exit 0" >> postinst
        chmod 0755 postinst
}
