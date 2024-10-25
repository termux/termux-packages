TERMUX_PKG_HOMEPAGE=https://github.com/mikebrady/shairport-sync
TERMUX_PKG_DESCRIPTION="An AirPlay audio player"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSES"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.4"
TERMUX_PKG_SRCURL=https://github.com/mikebrady/shairport-sync/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3173cc54d06f6186a04509947697b56c7eac09c48153d7dea5f702042620a2df
TERMUX_PKG_DEPENDS="libao, libconfig, libdaemon, libpopt, libsndfile, libsoxr, openssl, pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true
# Airplay2 requires nqptp so we do not activate it
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-pa
--with-libdaemon
--with-stdout
--with-ao
--with-pipe
--with-ssl=openssl
--with-metadata
--with-tinysvcmdns
--with-soxr
--with-convolution
--with-ssl=openssl
--with-piddir=$TERMUX_PREFIX/tmp/
"

termux_step_pre_configure() {
	sed -i 's/-Wno-clobbered//g' "$TERMUX_PKG_SRCDIR/Makefile.am"
	autoreconf -fi
	
	"$CC" "$TERMUX_PKG_BUILDER_DIR/pthread_cancel_impl.c" -c -o "$TERMUX_PKG_BUILDDIR/pthread_cancel_impl.o"

	LDFLAGS+=" $TERMUX_PKG_BUILDDIR/pthread_cancel_impl.o"
	CFLAGS+=" -fcommon"
}

termux_step_post_configure() {
	echo "#include <$TERMUX_PKG_BUILDER_DIR/pthread_cancel_impl.h>" >> "$TERMUX_PKG_BUILDDIR/config.h"
	echo "#define bzero(poi,len) memset(poi,0,len)" >> "$TERMUX_PKG_BUILDDIR/config.h"
	echo "#define MAC_FILE_PATH \"$TERMUX_PREFIX/share/shairport-sync/MAC.txt\"" >> "$TERMUX_PKG_BUILDDIR/config.h"
}
