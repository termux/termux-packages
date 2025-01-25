TERMUX_PKG_HOMEPAGE=https://packages.qa.debian.org/f/fakeroot.html
TERMUX_PKG_DESCRIPTION="Tool for simulating superuser privileges (with tcp ipc)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.37"
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=9831cc912bc1da6dadac15699c5a07a82c00d6f0dd5c15ec02e20908dd527d3a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ipc=tcp"
TERMUX_PKG_BUILD_DEPENDS="libcap"

termux_step_pre_configure() {
	autoreconf -vfi

	CPPFLAGS+=" -D_ID_T"
}

termux_step_post_make_install() {
	ln -sfr "${TERMUX_PREFIX}/lib/libfakeroot-0.so" "${TERMUX_PREFIX}/lib/libfakeroot.so"
}

termux_step_create_debscripts() {
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "echo"
		echo "echo Fakeroot does not give you any real root permissions. This utility is primarily intended to be used for development purposes."
		echo "echo More info about usage at https://wiki.debian.org/FakeRoot."
		echo "echo"
		echo "echo Programs requiring real root permissions will not run under fakeroot. Do not post bug reports about this."
		echo "echo"
	} > ./postinst
}
