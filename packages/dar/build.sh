TERMUX_PKG_HOMEPAGE=http://dar.linux.free.fr/
TERMUX_PKG_DESCRIPTION="A full featured command-line backup tool, short for Disk ARchive"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.3"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/dar/dar/${TERMUX_PKG_VERSION}/dar-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=812648f4d85fa2fe63ddad811f1c392f02c8627b54f9a610a1b54f51fbd96512
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="attr, libbz2, libc++, libgcrypt, libgpg-error, liblzma, liblzo, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dar-static"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH_BITS" = "32" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-mode=32"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-mode=64"
	fi
	CXXFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
