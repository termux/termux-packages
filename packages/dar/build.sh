TERMUX_PKG_HOMEPAGE=http://dar.linux.free.fr/
TERMUX_PKG_DESCRIPTION="A full featured command-line backup tool, short for Disk ARchive"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.6.12
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/dar/dar/${TERMUX_PKG_VERSION}/dar-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d3ef3ad2fc9b5199333fc462e68b49498eb6e2c3e5472e6f9b7aa42b6a548f4b
TERMUX_PKG_DEPENDS="attr, libbz2, libgcrypt, liblzma, liblzo, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH_BITS" = "32" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-mode=32"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-mode=64"
	fi
	CXXFLAGS+=" $CPPFLAGS"
}
