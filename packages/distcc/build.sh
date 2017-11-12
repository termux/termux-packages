TERMUX_PKG_HOMEPAGE=http://distcc.org/
TERMUX_PKG_DESCRIPTION="Distributed C/C++ compiler."
TERMUX_PKG_VERSION=3.2-rc1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=8cf474b9e20f5f3608888c6bff1b5f804a9dfc69ae9704e3d5bdc92f0487760a
TERMUX_PKG_SRCURL=https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/distcc/distcc-3.2rc1.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	#the configure script checks if $PYTHON is executable
        PYTHON=/etc/hosts sh ./configure -disable-Werror --without-libiberty --prefix=/usr --host `dpkg-architecture -q DEB_HOST_GNU_TYPE`
}
